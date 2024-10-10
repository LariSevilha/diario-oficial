# frozen_string_literal: true

require 'nokogiri'

def pluralize(word)
  "#{word}s"
end

def style_show_view(file_path, model_name, attributes)
  File.read(file_path)

  # Construir as linhas dinamicamente com tradução
  attribute_lines = attributes.map do |attribute|
    <<-HTML
    <strong><%= t('activerecord.attributes.#{model_name}.#{attribute}') %>:</strong><br>
    <%= @#{model_name}.#{attribute} %><br>
    HTML
  end.join("\n                      ")

  updated_show = <<~HTML
    <div class="page-content-wrapper ">
      <div class="container-fluid">
        <div class="row d-print-none">
          <div class="col-sm-12">
            <h5 class="page-title">Detalhes</h5>
          </div>
        </div>
        <div class="row">
          <div class="col-12">
            <div class="card m-b-30">
              <div class="card-body">
                <div class="row">
                  <div class="col-12">
                    <div class="invoice-title"></div>
                    <div class="row">
                      <div class="col-6">
                        <address>
                          #{attribute_lines}
                        </address>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="d-print-none mo-mt-2">
                  <div class="float-right">
                    <%= link_to 'Editar', edit_admin_#{model_name}_path(@#{model_name}), class: 'btn btn-success waves-effect waves-light' %>
                    <%= link_to 'Voltar', admin_#{pluralize(model_name)}_path, class: 'btn btn-primary waves-effect waves-light' %>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  HTML

  # Salvar o arquivo ERB modificado
  File.write(file_path, updated_show)
end

# Caminho do arquivo de show gerado pelo scaffold
show_file_path = ARGV[0]
model_name = ARGV[1]
attributes = ARGV[2..]

if File.exist?(show_file_path)
  style_show_view(show_file_path, model_name, attributes)
  puts "Estilos adicionados com sucesso ao show: #{show_file_path}"
else
  puts "Arquivo de show não encontrado: #{show_file_path}"
end
