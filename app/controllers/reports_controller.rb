# frozen_string_literal: true

class ReportsController < ApplicationController
  include PdfHelper

  def show
    @report = Report.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        generate_report_with_wicked_pdf
      end
    end
  end

  private

  def generate_report_with_wicked_pdf
    # Gerar o PDF principal usando WickedPdf
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('reports/show.html.erb'),
      layout: 'pdf_advanced',
      header: { content: "<h1>Relatório - #{@report.title}</h1>" },
      footer: { content: "<p>Page <span class='page_number'></span> of <span class='total_pages'></span></p>" },
      orientation: 'Portrait'
    )

    # Obtém os caminhos dos PDFs anexos
    attachment_pdfs = @report.file_sections.map { |fs| fs.file.path }

    # Combina o PDF principal com os anexos
    combine_pdfs(pdf, attachment_pdfs)

    # Envia o PDF combinado como resposta
    send_file('combined_report.pdf', type: 'application/pdf', disposition: 'inline')
  end
end
