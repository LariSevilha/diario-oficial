# frozen_string_literal: true

module PdfHelper
  include CertificateHelper
  
  require 'prawn'
  require 'sanitize'
  require 'htmlentities'
  require 'prawn/text/formatted' 
  require 'nokogiri'

  # Configura fontes personalizadas para o PDF
  def self.setup_fonts(pdf)
    pdf.font_families.update(
      'CustomFont' => {
        normal: Rails.root.join('app', 'assets', 'fonts', 'dejavu-sans', 'DejaVuSans.ttf').to_s,
        bold: Rails.root.join('app', 'assets', 'fonts', 'dejavu-sans', 'DejaVuSans-Bold.ttf').to_s,
        italic: Rails.root.join('app', 'assets', 'fonts', 'freeserif', 'FreeSerif', 'FreeSerifItalic.ttf').to_s
      }
    )
  end

  # Adiciona a capa ao PDF combinado
  def add_cover_page(combined_pdf)
    cover_path = generate_cover(@certificate, @private_key)
    combined_pdf << CombinePDF.load(cover_path)
    cover_path
  end

  # Adiciona cabeçalho e rodapé a cada página (exceto capa)
  def add_header_and_footer(combined_pdf)
    combined_pdf.pages.each_with_index do |page, index|
      next if index.zero? # Ignora a capa

      add_header_to_page(page, index, combined_pdf.pages.count - 1)
      add_footer_to_page(page)
    end
  end

  # Método auxiliar para adicionar o cabeçalho a uma página
  def add_header_to_page(page, index, total_pages)
    header_pdf_path = generate_header_pdf(index, total_pages)
    header_pdf = CombinePDF.load(header_pdf_path)
    page << header_pdf.pages[0]
    File.delete(header_pdf_path) if File.exist?(header_pdf_path)
  end
  
  # Método auxiliar para adicionar o rodapé a uma página
  def add_footer_to_page(page)
    footer_pdf_path = generate_footer_pdf
    footer_pdf = CombinePDF.load(footer_pdf_path)
    page << footer_pdf.pages[0]
    File.delete(footer_pdf_path) if File.exist?(footer_pdf_path)
  end

  # Gera o PDF do cabeçalho
  def generate_header_pdf(index, total_pages)
    header_pdf_path = "temp_header_page_#{index}.pdf"
    Prawn::Document.generate(header_pdf_path, page_size: 'A4') do |pdf|
      PdfHelper.setup_fonts(pdf)
      pdf.font_size 8

      pdf.move_down 90

      roman_year = to_roman(Time.now.year)
      pdf.font('CustomFont') do
        pdf.text_box "#{roman_year} | #{entity.name_diary} - Edição #{entity.number_edition}",
          at: [0, pdf.bounds.top - 60], width: pdf.bounds.width / 3, align: :left

        pdf.text_box I18n.l(Time.now.to_date, format: :long),
          at: [pdf.bounds.width / 3, pdf.bounds.top - 60], width: pdf.bounds.width / 3, align: :center

        pdf.text_box "Página #{index}/#{total_pages}",
          at: [2 * pdf.bounds.width / 3, pdf.bounds.top - 60], width: pdf.bounds.width / 3, align: :right
      end
    end
    header_pdf_path
  end

  def generate_footer_pdf
    footer_pdf_path = 'temp_footer_page.pdf'
    Prawn::Document.generate(footer_pdf_path, page_size: 'A4') do |pdf|
      PdfHelper.setup_fonts(pdf)
      pdf.font_size 8
      pdf.fill_color 'FFFFFF'
      pdf.fill_rectangle [0, 30], pdf.bounds.width, 30
      pdf.fill_color '000000'
      pdf.text_box "Diário Oficial - #{entity.name_diary}", at: [2, 42], width: pdf.bounds.width, align: :center
      pdf.text_box entity.law, at: [1, 20], width: pdf.bounds.width, align: :center
    end
    footer_pdf_path
  end

  # Gera a capa do PDF
  def generate_cover(certificate, _private_key)
    cover_pdf_path = Rails.root.join('tmp', "cover_pdf_#{id}.pdf").to_s
    Prawn::Document.generate(cover_pdf_path, page_size: 'A4') do |pdf|
      PdfHelper.setup_fonts(pdf)

      # Adiciona o logo se disponível
      if entity.logo.present? && (logo_path = entity.logo.path)
        pdf.image logo_path, at: [(pdf.bounds.width - 70) / 2, pdf.cursor], width: 70
        pdf.move_down 30
      end

      pdf.move_down 60
      pdf.font("CustomFont", style: :italic) do
        pdf.font_size 26
        pdf.text "DIÁRIO OFICIAL", align: :center
      end
      pdf.move_down 16
      pdf.font_size 14
      pdf.text entity.name_entity.to_s, align: :center, style: :bold
      pdf.move_down 10
      pdf.font_size 12
      pdf.text entity.law, align: :center
      pdf.move_down 20

      generate_cover_box(pdf)
      generate_signature_block(pdf, certificate)
 
      add_icp_stamp(pdf)
    end
    cover_pdf_path
  end

  def generate_cover_box(pdf)
    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 20) do
      pdf.fill_color '000000'
      pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 20
      pdf.fill_color 'FFFFFF'
      roman_year = to_roman(Time.now.year)
      pdf.text_box "ANO - #{roman_year} | #{entity.name_diary}", at: [5, 15], width: pdf.bounds.width / 3, align: :left
      pdf.text_box I18n.l(Time.now.to_date, format: :long).to_s, at: [pdf.bounds.width / 3, 15],
                                                                 width: pdf.bounds.width / 3, align: :center
      pdf.text_box "Número #{entity.number_edition}", at: [2 * pdf.bounds.width / 3, 15], width: pdf.bounds.width / 3,
                                                      align: :right
    end
    pdf.fill_color '000000'
  
    pdf.move_down 20
  
    # Define a largura de cada coluna
    column_width = (pdf.bounds.width / 2) - 10
  
    # Posição inicial para ambas as caixas
    start_cursor = pdf.cursor
  
    # Caixa para o sumário (coluna esquerda)
    pdf.bounding_box([0, start_cursor], width: column_width, height: 450) do
      pdf.fill_color 'DDDDDD'
      pdf.fill_rectangle [0, 450], column_width, 450
      pdf.fill_color '000000'
      pdf.stroke_bounds
      pdf.move_down 10
      pdf.font_size 14
      pdf.text "SUMÁRIO", align: :center, style: :bold
      pdf.move_down 10
      add_summary(pdf)
    end
    
     # Caixa para o conteúdo do diário (coluna direita)    
    pdf.bounding_box([column_width + 20, start_cursor], width: column_width, height: 450) do
      pdf.fill_color 'DDDDDD'
      pdf.fill_rectangle [0, 450], column_width, 450
      pdf.fill_color '000000'
      pdf.stroke_bounds
      pdf.move_down 10
      pdf.font_size 14
    
      # Limpar o conteúdo do diário para remover tags HTML
      clean_content = Sanitize.fragment(entity.diary_content)
    
      # Inserir o conteúdo limpo do diário
      pdf.text clean_content, align: :left
    
      pdf.move_down 10
      # add_content(pdf)
    end
  end
  
  def add_summary(pdf)
    pdf.font_size 10
    page_number = 1  
  
    sections.each do |section| 
      government_text = "#{section.branch_government.name}"
      page_number_text = "#{page_number}"
      
      # Adiciona os pontos e o número da página para o nome do governo
      pdf.text "#{government_text}#{'.' * (65 - government_text.length - page_number_text.length)}#{page_number_text}", style: :bold
  
      pdf.indent(10) do
        # Categoria do diário
        category_text = "#{section.diary_category.name}"
        page_number_text = "#{page_number}"
   
        pdf.text "#{category_text}#{'.' * (65 - category_text.length - page_number_text.length)}#{page_number_text}",style: :bold
  
        if section.diary_sub_category.present?
          pdf.indent(5) do 
            sub_category_text = "#{section.diary_sub_category.name}"
            page_number_text = "#{page_number}"
   
            pdf.text "#{sub_category_text}#{'.' * (65 - sub_category_text.length - page_number_text.length)}#{page_number_text}"
          end
        end
      end 
      page_number += 1
      pdf.move_down 5
    end
  end 
  
  # def add_content(pdf)
  #   pdf.font_size 10
    
  #   # sanitized_content = Sanitize.fragment(entity.diary_content.to_s, elements: ['b', 'strong', 'br'])
  #   # decoded_content = HTMLEntities.new.decode(sanitized_content)
    
  #   # render_html_content(pdf, decoded_content)
  # end
  
  def render_html_content(pdf, html_content)
    doc = Nokogiri::HTML::DocumentFragment.parse(html_content)
    doc.children.each do |node|
      case node.name
      when 'b', 'strong'
        pdf.text node.text, style: :bold
      when 'br'
        pdf.move_down 5
      else 
        text = node.text.gsub("\t", ' ' * 4)
        pdf.text text
      end
    end
  end

  # Gera o bloco de assinatura digital na capa
  def generate_signature_block(pdf, certificate)
    pdf.font_size 8
    if certificate.present?
      pdf.text_box "<b>ESTA EDIÇÃO FOI ASSINADA DIGITALMENTE POR:</b>\n#{responsavel_nome}\n\n#{certificate.subject}",
        at: [pdf.bounds.right - 200, pdf.bounds.bottom + 100], width: 200, height: 100, align: :right, valign: :bottom, inline_format: true
    else
      pdf.text_box "<b>DOCUMENTO NÃO OFICIAL</b>",
        at: [pdf.bounds.right - 200, pdf.bounds.bottom + 100], width: 200, height: 100, align: :right, valign: :bottom, inline_format: true
    end
  end

  # Combina PDFs principais e anexos
  def combine_pdfs(main_pdf, attachment_pdfs)
    combined_pdf = CombinePDF.new
    combined_pdf << CombinePDF.load(main_pdf.path)

    attachment_pdfs.each do |pdf_file|
      combined_pdf << CombinePDF.load(pdf_file.path)
    end

    combined_pdf.save('combined_report.pdf')
  end

  # Converte números para algarismos romanos
  def to_roman(num)
    roman_mapping = [
      ['M', 1000], ['CM', 900], ['D', 500], ['CD', 400],
      ['C', 100], ['XC', 90], ['L', 50], ['XL', 40],
      ['X', 10], ['IX', 9], ['V', 5], ['IV', 4],
      ['I', 1]
    ]

    result = ''
    roman_mapping.each do |pair|
      letter, value = pair
      while num >= value
        result += letter
        num -= value
      end
    end
    result
  end
   
  # Adiciona selo ICP à capa
  def add_icp_stamp(pdf)
    icp_image_path = Rails.root.join('app', 'assets', 'images', 'icp.jpeg').to_s
    return unless File.exist?(icp_image_path)

    pdf.text_box 'Diário Oficial assinado eletrônicamente com Certificado digital Padrão ICP-Brasil em conformidade com MP nº 2.200-2 de 2001. O sistema de gestão garante a autenticidade do material gerado dentro do sistema.',
                 at: [90, pdf.bounds.bottom + 100],
                 width: 200,
                 height: 100,
                 align: :left,
                 valign: :bottom
    pdf.image icp_image_path, at: [0, pdf.bounds.bottom + 60], width: 80, height: 80
  end 
end
