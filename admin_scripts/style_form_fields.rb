# frozen_string_literal: true

require 'nokogiri'

# Mapeamento de tipos de campos para suas classes de estilo específicas
FIELD_STYLES = {
  'text_field' => 'form-control',
  'text_area' => 'summernote',
  'email_field' => 'form-control',
  'url_field' => 'form-control',
  'tel_field' => 'form-control',
  'password_field' => 'form-control',
  'number_field' => 'form-control',
  'search_field' => 'form-control',
  'date_field' => 'form-control',
  'datetime_field' => 'form-control',
  'time_field' => 'form-control',
  'month_field' => 'form-control',
  'week_field' => 'form-control',
  'color_field' => 'form-control'
}.freeze

BUTTON_STYLE = 'btn btn-primary waves-effect waves-light'

def add_styles_to_form_fields_and_errors(file_path, model_name)
  content = File.read(file_path)

  # Remover bloco de erros gerado pelo scaffold
  scaffold_error_block = %r{<% if @#{model_name}\.errors\.any\? %>\s*<div id="error_explanation">\s*<h2><%= pluralize\(@#{model_name}\.errors\.count, "error"\) %> prohibited this #{model_name} from being saved:</h2>\s*<ul>\s*<% @#{model_name}\.errors\.full_messages\.each do \|msg\| %>\s*<li><%= msg %></li>\s*<% end %>\s*</ul>\s*</div>\s*<% end %>}m
  content.gsub!(scaffold_error_block, '')

  # Adicionar bloco de erros estilizado
  styled_error_block = <<~HTML
    <% if @#{model_name}.errors.any? %>
      <div class="alert alert-danger alert-dismissible fade show mb-0" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <div id="error_explanation">
          <h2><%= pluralize(@#{model_name}.errors.count, "erros") %> não permitiram salvar:</h2>
          <ul>
            <% @#{model_name}.errors.full_messages.each do |msg| %>
              <li><%= msg %></li>
            <% end %>
          </ul>
        </div>
      </div>
    <% end %>
  HTML

  # Inserir o bloco de erros estilizado no início do formulário
  content.sub!(/<%= form_for/, "#{styled_error_block}\n<%= form_for")

  # Envolver campos de entrada e seus rótulos em divs com classe "form-group"
  FIELD_STYLES.each do |field_type, style_class|
    content.gsub!(%r{<div class="field">\s*<%= f\.label :(\w+) %><br>\s*<%= f\.#{field_type} :\1(.*?) %>\s*</div>}m) do |_match|
      field = Regexp.last_match(1)
      options = Regexp.last_match(2)
      "<div class=\"form-group\">\n  <%= f.label :#{field} %><br>\n  <%= f.#{field_type} :#{field}#{options}, class: '#{style_class}' %>\n</div>"
    end
  end

  # Estilizar o botão de submit
  content.gsub!(%r{<div class="actions">\s*<%= f\.submit %>\s*</div>}, <<-HTML
  <div class="form-group">
    <button type="submit" class="#{BUTTON_STYLE}">
        Salvar
    </button>
  </div>
  HTML
  )

  # Adicionar estrutura do card ao formulário
  updated_form = <<~HTML
    <div class="row">
      <div class="col-12">
        <div class="card m-b-30">
          <div class="card-body">
            #{content}
          </div>
        </div>
      </div>
    </div>
  HTML

  # Salvar o arquivo ERB modificado
  File.write(file_path, updated_form)
end

# Caminho do arquivo de formulário gerado pelo scaffold
form_file_path = ARGV[0]
model_name = ARGV[1]

if File.exist?(form_file_path)
  add_styles_to_form_fields_and_errors(form_file_path, model_name)
  puts "Estilos adicionados com sucesso ao formulário: #{form_file_path}"
else
  puts "Arquivo de formulário não encontrado: #{form_file_path}"
end
