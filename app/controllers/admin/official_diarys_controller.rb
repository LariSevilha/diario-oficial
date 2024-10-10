# frozen_string_literal: true

module Admin
  class OfficialDiarysController < ApplicationController
    layout 'admin'
    before_action :set_official_diary, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/official_diarys
    def index
      @official_diarys = if !current_user.logged.nil?
                           OfficialDiary.where(entity_id: current_user.logged).accessible_by(current_ability)
                         else
                           OfficialDiary.accessible_by(current_ability)
                         end
      if params[:query].present?
        query = params[:query].downcase
        @official_diarys = @official_diarys.where(build_search_query(OfficialDiary,
                                                                     query)).order(id: :desc).page(params[:page]).per(10)
      else
        @official_diarys = @official_diarys.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/official_diarys/1
    def show
      # @combined_file_url = combined_file_url(@official_diary)
    end

   # GET /admin/official_diarys/new
    def new
      entity_id = current_user.logged
      @official_diary = OfficialDiary.create!(edition: OfficialDiary.edition_number(entity_id), entity_id: entity_id)
      redirect_to edit_admin_official_diary_path(@official_diary), notice: 'Diário criado com sucesso, preencha as informações restantes.'
    end

    # GET /admin/official_diarys/1/edit
    def edit
      @official_diary = OfficialDiary.find(params[:id])
    
      # Prevent editing if the diary is published
      if @official_diary.published?
        flash[:alert] = 'Este diário já foi publicado e não pode ser editado.'
        redirect_to admin_official_diary_path(@official_diary) and return
      end
    end
    # POST /admin/official_diarys
    def create
      @official_diary = OfficialDiary.new(official_diary_params)
      @official_diary.temp_password = params[:official_diary][:temp_password]

      if @official_diary.save
        @official_diary.generate_and_combine_pdf

        if @official_diary.save
          redirect_to [:admin, @official_diary], notice: 'Diário oficial salvo com sucesso e PDF combinado gerado!'
        else
          render :new, alert: 'Falha ao gerar o PDF combinado.'
        end
      else
        render :new
      end
    end

    def download_text_pdf
      @diary = OfficialDiary.find(params[:id])
      @section = @diary.sections.find(params[:section_id])

      sanitized_text = Sanitize.fragment(@section.description, elements: %w[b i u strong em p],
                                                               attributes: {})

      # Generate PDF with sanitized content
      pdf = Prawn::Document.new
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
      send_data pdf.render, filename: "diary_#{@diary.id}_section_#{@section.id}.pdf", type: 'application/pdf',
                            disposition: 'inline'
    end

    def download_combined_pdf
      @official_diary = OfficialDiary.find(params[:id])
    
      if @official_diary.combined_file.present?
        redirect_to @official_diary.combined_file.url, disposition: 'attachment'
      else
        flash[:alert] = 'PDF não encontrado.'
        respond_to do |format|
          format.html { render plain: 'PDF não encontrado.', status: :not_found }
          format.json { render json: { error: 'PDF não encontrado.' }, status: :not_found }
        end
      end
    end
    def update
      @official_diary = OfficialDiary.find(params[:id])
    
      # Prevent editing if the diary is published
      if @official_diary.published?
        flash[:alert] = 'Este diário já foi publicado e não pode ser editado.'
        redirect_to admin_official_diary_path(@official_diary) and return
      end
    
      if @official_diary.update(official_diary_params)
        # Gera o PDF combinado após a atualização
        @official_diary.generate_and_combine_pdf
    
        if @official_diary.save
          redirect_to [:admin, @official_diary], notice: 'Diário oficial atualizado com sucesso e PDF combinado gerado!'
        else
          render :edit, alert: 'Falha ao gerar o PDF combinado.'
        end
      else
        render :edit
      end
    end
    # DELETE /admin/official_diarys/1
    def destroy
      @official_diary.destroy
      redirect_to admin_official_diarys_url, notice: 'Deletado com sucesso!'
    end

    def publish_diary
      @official_diary = OfficialDiary.find(params[:id])
      @official_diary.temp_password = params[:official_diary][:temp_password]
      @official_diary.certificate = params[:official_diary][:certificate]
    
      if @official_diary.process_pfx_file
        if @official_diary.update(published: true)  
          @official_diary.generate_and_combine_pdf
          @official_diary.save
    
          flash[:notice] = 'Diário publicado com sucesso.'
          redirect_to admin_official_diarys_path
        else
          flash[:alert] = 'Ocorreu um erro ao publicar o diário.'
          redirect_to admin_official_diarys_path
        end
      else
        respond_to do |format|
          format.js { render js: "alert('Senha do certificado incorreta ou arquivo PFX inválido.');" }
        end
      end
    end
    
    
    def edit
      @official_diary = OfficialDiary.find(params[:id])
    
      if @official_diary.published?
        flash[:alert] = 'Este diário já foi publicado e não pode ser editado.'
        redirect_to admin_official_diary_path(@official_diary) and return
      end
    end
    
    private

    # Use callbacks to share common setup or constraints between actions.
    def set_official_diary
      @official_diary = OfficialDiary.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def official_diary_params
      params.require(:official_diary).permit(:edition, :text, :slug, :certificate, :branch_government_id,
                                             :diary_category_id, :diary_sub_category_id, :temp_password, :entity_id)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end


