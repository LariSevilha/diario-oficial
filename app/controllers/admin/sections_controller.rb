# frozen_string_literal: true

require 'prawn'
require 'sanitize'

module Admin
  class SectionsController < ApplicationController
    before_action :set_section, only: %i[show edit update destroy]

    # GET /admin/sections
    def index
      @sections = Section.all
    end

    # GET /admin/sections/1
    def show
      respond_to do |format|
        format.html
        format.pdf do
          if @section.official_diary.combined_pdf_path.present?
            send_file @section.official_diary.combined_pdf_path,
                      filename: "combined_diary_#{@section.official_diary.id}.pdf", type: 'application/pdf'
          else
            render json: { error: 'Combined PDF not available' }, status: :not_found
          end
        end
      end
    end

    # GET /admin/sections/new
    def new
      @section = Section.new
    end

    # POST /admin/sections
    def create
      puts "Entrouuuuuuu"
      @section = Section.new(section_params.except(:file_sections))

      if @section.save
        generate_and_save_pdf(@section)
        # Section.combine_pdfs_for_diary(@section.official_diary_id)
        if params[:section][:file_sections].present?
          params[:section][:file_sections].each do |file|
            @section.file_sections.create(file:)
          end
        end
        respond_to do |format|
          format.json do
            render json: {
              success: true,
              section: {
                id: @section.id,
                title: @section.title,
                branch_government_name: @section.branch_government.try(:name),
                diary_category_name: @section.diary_category.try(:name),
                diary_sub_category_name: @section.diary_sub_category.try(:name),
                description: @section.description,
                content_type: @section.content_type
              }
            }
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: { success: false, errors: @section.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end

    # PATCH/PUT /admin/sections/1
    def update
      if @section.update(section_params.except(:file_sections))
        if params[:section][:file_sections].present?
          params[:section][:file_sections].each do |file|
            @section.file_sections.create(file: file)
          end
        end
        # Regenera o PDF combinado após a atualização da seção
        @section.official_diary.generate_and_combine_pdf

        respond_to do |format|
          format.json do
            render json: { success: true, section: section_response_data(@section) }
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: { success: false, errors: @section.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end

    def section_response_data(section)
      {
        id: section.id,
        title: section.title,
        branch_government_name: section.branch_government.try(:name),
        diary_category_name: section.diary_category.try(:name),
        diary_sub_category_name: section.diary_sub_category.try(:name),
        description: section.description,
        content_type: section.content_type,
        files: section.file_sections.map do |file_section|
          {
            id: file_section.id,
            file_name: file_section.file_identifier,
            file_url: file_section.file.url
          }
        end
      }
    end    

    def edit
      @section = Section.find(params[:id])
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            section: {
              id: @section.id,
              title: @section.title,
              branch_government_id: @section.branch_government_id,
              diary_category_id: @section.diary_category_id,
              diary_sub_category_id: @section.diary_sub_category_id,
              description: @section.description,
              content_type: @section.content_type,
              files: @section.file_sections.map do |file_section|
                {
                  id: file_section.id,
                  file_name: file_section.file_identifier,
                  file_url: file_section.file.url
                }
              end
            }
          }
        end
      end
    end

    # DELETE /admin/sections/1
    def destroy
      official_diary_id = @section.official_diary_id

      if @section.destroy
        # Regenera o PDF combinado após a exclusão da seção
        OfficialDiary.find(official_diary_id).generate_and_combine_pdf

        respond_to do |format|
          format.json { render json: { success: true } }
        end
      else
        respond_to do |format|
          format.json do
            render json: { success: false, errors: @section.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    def section_params
      params.require(:section).permit(:description, :branch_government_id, :diary_category_id,
                                      :title, :diary_sub_category_id, :official_diary_id, :content_type, file_sections: [])
    end

    def generate_and_save_pdf(section)
      pdf = Prawn::Document.new
      sanitized_text = Sanitize.fragment(section.description, elements: %w[b i u strong em p],
                                                              attributes: {})

      if sanitized_text.present?
        pdf.bounding_box([0, pdf.cursor - 50], width: pdf.bounds.width, height: pdf.bounds.height - 100) do
          doc = Nokogiri::HTML(sanitized_text)
          paragraphs = doc.css('p').map(&:inner_html).reject(&:empty?)
          paragraphs.each do |paragraph|
            pdf.text paragraph, align: :justify, inline_format: true
            pdf.move_down 10
          end
        end
      end

      # Save the generated PDF to a file
      pdf_path = Rails.root.join('tmp', "section_pdf_#{section.id}.pdf")
      pdf.render_file(pdf_path)

      # Update the section with the PDF path
      section.update_column(:pdf_section, pdf_path.to_s)
    end
  end
end
