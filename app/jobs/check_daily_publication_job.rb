class CheckDailyPublicationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    cutoff_time = Time.zone.now.beginning_of_day + 14.hours + 30.minutes
    
    published_diaries = OfficialDiary.where('published = ? AND created_at <= ?', true, cutoff_time)

    if published_diaries.empty?
      entity_id = current_entity.id  # Obtém a entidade logada

      OfficialDiary.create!(
        edition: OfficialDiary.edition_number(entity_id),
        entity_id: entity_id,
        text: 'Sem atos oficiais',
        published: true
      ) do |diary|
        generate_empty_pdf(diary)
      end
    end
  end

  private

  def generate_empty_pdf(diary)
    pdf = Prawn::Document.new
    pdf.text "Sem atos oficiais", size: 24, align: :center, valign: :center

    pdf_path = Rails.root.join('tmp', "sem_atos_oficiais_#{diary.id}.pdf")
    pdf.render_file(pdf_path)

    diary.combined_file = File.open(pdf_path)
    diary.save

    File.delete(pdf_path) if File.exist?(pdf_path)
  end

  # Método auxiliar para obter a entidade logada
  def current_entity
    # Implementação para obter a entidade logada
    # Exemplo: User.current.entity
    User.current.entity
  end
end