# frozen_string_literal: true

class OfficialDiary < ApplicationRecord
  require 'nokogiri'
  require 'prawn'
  require 'combine_pdf'

  belongs_to :entity

  has_many :sections, dependent: :destroy
  accepts_nested_attributes_for :sections, allow_destroy: true

  mount_uploader :certificate, CertificateUploader
  mount_uploader :combined_file, PdfFinishUploader

  include CertificateHelper
  include PdfHelper

  after_save :process_pfx_file, if: :certificate_password_present?
  after_save :generate_and_combine_pdf, unless: :new_record?

  attr_accessor :temp_password, :responsavel_nome, :responsavel_cpf, :subject
 
  def published?
    self.published == true
  end
  
  def certificate_password_present?
    temp_password.present?
  end

  def self.edition_number(entity)
    official_diary = OfficialDiary.where(entity_id: entity).last
    if official_diary.present?
      official_diary.edition + 1
    else
      Entity.find_by_id(entity).number_edition + 1
    end
  end

  def generate_and_combine_pdf
    combined_pdf = CombinePDF.new
    
    # Adiciona a capa
    cover_pdf_path = add_cover_page(combined_pdf)

    pdf = Prawn::Document.new(top_margin: 80) # Definindo uma margem superior de 80 unidades
    
    pdf.move_down 30 

    all_sections = sections.order(:created_at)

    all_sections.each do |section|
    
      add_branch_government_and_category(pdf, section)
      pdf.move_down 20
      
      section.generate_pdf(pdf)
    end 

    # Finaliza a criação do PDF global das seções e salva temporariamente
    pdf_path = Rails.root.join('tmp', "all_sections_pdf_#{id}.pdf")
    pdf.render_file(pdf_path)
    combined_pdf << CombinePDF.load(pdf_path)
    File.delete(pdf_path) if File.exist?(pdf_path)

    add_header_and_footer(combined_pdf)

    combined_pdf_path = Rails.root.join('tmp', "combined_official_diary_pdf_#{id}.pdf")
    combined_pdf.save combined_pdf_path

    File.delete(cover_pdf_path) if File.exist?(cover_pdf_path)

    self.combined_file = File.open(combined_pdf_path)

    File.delete(combined_pdf_path) if File.exist?(combined_pdf_path)
  end

  private

  def add_branch_government_and_category(pdf, section)
    pdf.move_down 10
  
    # Define a cor de preenchimento para cinza claro
    pdf.fill_color 'EAEAEA'
   
    session_id_height = pdf.height_of("IDENTIFICADOR DA SESSÃO: #{section.id}", size: 10, align: :center) + 10
   
    pdf.fill_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, session_id_height
   
    pdf.stroke_color '000000'
    pdf.stroke_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, session_id_height
   
    pdf.fill_color '000000'
   
    pdf.move_down 5
    pdf.text "IDENTIFICADOR DA SESSÃO: #{section.id}", align: :center, size: 10
    pdf.move_down 5
   
    branch_government_height = pdf.height_of("#{section.branch_government.name}", size: 10, align: :center) + 10
   
    pdf.fill_color 'EAEAEA'
 
    pdf.fill_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, branch_government_height
   
    pdf.stroke_color '000000'
    pdf.stroke_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, branch_government_height
   
    pdf.fill_color '000000'
   
    pdf.move_down 5
    pdf.text "#{section.branch_government.name}", align: :center, size: 10
    pdf.move_down 5
  
    # Calcula a altura do conteúdo para o diary_category
    diary_category_height = pdf.height_of("#{section.diary_category.name}", size: 10, align: :center) + 10
   
    pdf.fill_color 'EAEAEA'
   
    pdf.fill_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, diary_category_height
  
    # Desenha a borda preta ao redor do retângulo
    pdf.stroke_color '000000'
    pdf.stroke_rectangle [pdf.bounds.left, pdf.cursor], pdf.bounds.width, diary_category_height
  
    # Redefine a cor de preenchimento para preto
    pdf.fill_color '000000'
   
    pdf.move_down 5
    pdf.text "#{section.diary_category.name}", align: :center, size: 10
    pdf.move_down 5
    
    pdf.stroke_horizontal_rule
    pdf.move_down 10
  end
end
