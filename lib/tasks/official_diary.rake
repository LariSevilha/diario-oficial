namespace :official_diary do
  desc "Verifica publicações e gera PDF se necessário"
  task check_publication: :environment do
    current_time = Time.now

    # Verifica se já passou das 15:20
    if current_time.hour == 15 && current_time.min >= 20
      # Verifica se há algum OfficialDiary publicado (published == true) hoje
      if OfficialDiary.where("DATE(created_at) = ? AND published = ?", Date.today, true).exists?
        puts "Já há uma publicação oficial para hoje."
      else
        # Caso contrário, verifica se há algum diário não publicado (published == false)
        if OfficialDiary.where("DATE(created_at) = ? AND published = ?", Date.today, false).exists?
          puts "Diário não publicado já existente para hoje. Publicação automática não será feita."
        else
          # Gera o PDF "sem atos oficiais" e cria um novo registro
          pdf_path = generate_pdf("sem atos oficiais")
           
          def current_entity 
            Entity.find_by(user_id: current_user.id)
          end
          
          # Modifique o código para usar a entidade logada
          OfficialDiary.create!(
            content: "Publicação automática: sem atos oficiais", 
            published: true, 
            entity: current_entity  
          )
          puts "Publicação automática gerada: 'sem atos oficiais'."
        end
      end
    else
      puts "Ainda não é hora de verificar publicações."
    end
  end

  # Método para gerar o PDF com a mensagem "sem atos oficiais"
  def generate_pdf(content)
    pdf = Prawn::Document.new
    pdf.text content, align: :center, size: 20, style: :bold
    
    # Gera o caminho do PDF temporário
    pdf_path = Rails.root.join("tmp", "diario_oficial_#{Date.today}.pdf")
    
    # Renderiza o PDF no caminho especificado
    pdf.render_file(pdf_path)
    
    begin 
      send_data File.read(pdf_path), filename: "diario_oficial_#{Date.today}.pdf", type: "application/pdf"
      
    ensure
      # Apaga o arquivo temporário
      File.delete(pdf_path) if File.exist?(pdf_path)
    end
  end

end


## ./run rake official_diary:check_publication