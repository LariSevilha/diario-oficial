namespace :official_diary do
  desc "Verifica se há diários publicados até as 14h e cria um PDF se não houver"
  task check_and_publish: :environment do
    # Verifique se existe algum diário oficial publicado hoje até as 14h
    published_today = OfficialDiary.where("created_at >= ? AND created_at <= ?", Date.today.beginning_of_day, Time.zone.now.end_of_day)

    if published_today.empty?
      # Se não houver, gera o PDF "Sem atos oficiais"
      pdf = Prawn::Document.new
      pdf.text "Sem atos oficiais", align: :center, size: 24, style: :bold
      filename = Rails.root.join("public", "diaries", "sem_atos_oficiais_#{Date.today}.pdf")

      pdf.render_file filename

      # Agora, cria o registro do diário oficial com o PDF gerado
      OfficialDiary.create!(
        title: "Sem atos oficiais",
        document: File.open(filename) # Supondo que você usa algum uploader para armazenar o PDF
      )

      puts "PDF 'Sem atos oficiais' criado e publicado."
    else
      puts "Já existe um diário oficial publicado hoje."
    end
  end
end
