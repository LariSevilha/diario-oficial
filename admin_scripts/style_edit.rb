# frozen_string_literal: true

require 'nokogiri'

def pluralize(word)
  "#{word}s"
end

def style_edit_view(file_path, model_name)
  File.read(file_path)

  updated_edit = <<~HTML
    <h1>Editar <%= t('activerecord.models.#{model_name}', count: 1) %></h1>

    <%= render 'form' %>

    <div class="row">
      <div class="col-12">
        <div class="card m-b-30">
          <div class="card-body" style= "background-color: #f0f3f5; border:none">
            <div class="d-print-none mo-mt-2">
              <div class="float-right">#{'    '}
                <%= link_to 'Voltar', admin_#{pluralize(model_name)}_path, class: 'btn btn-primary waves-effect waves-light' %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  HTML

  # Salvar o arquivo ERB modificado
  File.write(file_path, updated_edit)
end

# Caminho do arquivo de edit gerado pelo scaffold
edit_file_path = ARGV[0]
model_name = ARGV[1]

if File.exist?(edit_file_path)
  style_edit_view(edit_file_path, model_name)
  puts "Estilos adicionados com sucesso ao edit: #{edit_file_path}"
else
  puts "Arquivo de edit não encontrado: #{edit_file_path}"
end
