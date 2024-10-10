# frozen_string_literal: true

require 'prawn'
require 'combine_pdf'
require 'sanitize'
require 'pdf-reader'

class Section < ApplicationRecord
  belongs_to :branch_government
  belongs_to :diary_category
  belongs_to :diary_sub_category, optional: true
  belongs_to :official_diary

  has_many :file_sections, dependent: :destroy
  accepts_nested_attributes_for :file_sections, allow_destroy: true

  include PdfHelper

  enum content_type: {
    "Arquivo": 0,
    "Texto": 1
  }

  # Método que gera o PDF combinando texto e arquivos de seções
  def generate_pdf(pdf)
    combined_items = []

    # Adiciona o texto ao array, se existir
    if content_type == 'Texto'
      sanitized_text = Sanitize.fragment(description, elements: %w[b i u strong em p], attributes: {})
      
      if sanitized_text.present?
        doc = Nokogiri::HTML(sanitized_text)
        paragraphs = doc.css('p').map(&:inner_html).reject(&:empty?)

        combined_items << { type: 'text', content: paragraphs.join("\n\n"), created_at: self.created_at }
      end
    end

    # Adiciona os arquivos PDF da seção ao array
    file_sections.each do |file_section|
      if file_section.file.present?
        file_path_or_io = file_section.file.path.present? ? file_section.file.path : file_section.file.file
        pdf_reader = PDF::Reader.new(file_path_or_io)
        pdf_text = extract_text_from_pdf(pdf_reader)

        if pdf_text.present?
          combined_items << { type: 'file', content: pdf_text, created_at: file_section.created_at }
        end
      end
    end
 
    combined_items.sort_by! { |item| item[:created_at] } 
    bottom_margin = 15

    # Adiciona cada item ao PDF respeitando a área disponível
    combined_items.each do |item|
      ensure_fits_on_page(pdf, item[:content], bottom_margin)
      pdf.move_down 5   
      pdf.stroke_color 'DBDADA'  
      pdf.line_width 1   
      pdf.stroke_horizontal_rule    
    end
  end

  private
 
  def ensure_fits_on_page(pdf, content, bottom_margin, extra_margin = 10) 
    space_remaining = pdf.cursor - bottom_margin - extra_margin
   
    text_options = { width: pdf.bounds.width, inline_format: true }
   
    estimated_height = pdf.height_of(content, text_options)
   
    if estimated_height > space_remaining
      pdf.start_new_page
    end
   
    pdf.text(content, inline_format: true) if content.present?
  end
 
  def extract_text_from_pdf(reader)
    text = String.new   
    reader.pages.each do |page|
      text << page.text
    end

    text
  end
end