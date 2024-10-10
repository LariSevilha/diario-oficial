# frozen_string_literal: true

require 'nokogiri'

def pluralize(word)
  "#{word}s"
end

def style_new_view(file_path, model_name)
  File.read(file_path)

  updated_new = <<~HTML
    <h1>Cadastrar <%= t('activerecord.models.#{model_name}', count: 1) %></h1>

    <%= render 'form' %>

    <div class="row">
      <div class="col-12">
        <div class="card m-b-30">
          <div class="card-body" style= "background-color: #f0f3f5; border:none">
            <div class="d-print-none mo-mt-2">
              <div class="float-right">#{'    '}
                <%= link_to 'Cancelar', admin_#{pluralize(model_name)}_path, class: 'btn btn-primary waves-effect waves-light' %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  HTML

  # Salvar o arquivo ERB modificado
  File.write(file_path, updated_new)
end

# Caminho do arquivo de new gerado pelo scaffold
new_file_path = ARGV[0]
model_name = ARGV[1]

if File.exist?(new_file_path)
  style_new_view(new_file_path, model_name)
  puts "Estilos adicionados com sucesso ao new: #{new_file_path}"
else
  puts "Arquivo de new não encontrado: #{new_file_path}"
end
