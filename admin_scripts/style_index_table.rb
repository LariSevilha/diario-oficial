# frozen_string_literal: true

require 'nokogiri'

def pluralize(word)
  "#{word}s"
end

def style_index_table(file_path, model_name, column_names)
  File.read(file_path)

  # Adicionar 'id' ao início das colunas
  column_names.unshift('id') unless column_names.include?('id')

  # Construir cabeçalhos da tabela dinamicamente com tradução
  table_headers = column_names.map do |column|
    # Gera dinamicamente a chamada para a tradução do atributo
    translated_column = "<%= t('activerecord.attributes.#{model_name}.#{column}') %>"
    "<th>#{translated_column}</th>"
  end.join("\n                ")

  # Construir linhas da tabela dinamicamente
  table_rows = column_names.map { |column| "<td><%= #{model_name}.#{column} %></td>" }.join("\n                  ")

  updated_index = <<~HTML
    <%= render '/admin/shared/modal_delete' %>

    <div class="row">
      <div class="col-lg-12">
        <div class="card m-b-30">
          <div class="card-body">
            <h4 class="mt-0 header-title"><%= t('activerecord.models.#{model_name}', count: 2) %></h4>
            <%= render '/admin/shared/search' %> <!-- Campo de busca adicionado aqui -->
            <div class="table-responsive">
              <table class="table table-striped mb-0">
                <thead>
                  <tr>
                    #{table_headers}
                    <th></th>
                    <th></th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <% @#{pluralize(model_name)}.each do |#{model_name}| %>
                    <tr>
                      #{table_rows}
                      <td>
                        <%= link_to [:admin, #{model_name}], class: 'btn btn-success', title: 'Mostrar detalhes' do %>
                          <i class="fa fa-eye"></i>
                        <% end %>
                      </td>
                      <td>
                        <%= link_to edit_admin_#{model_name}_path(#{model_name}), class: 'btn btn-primary', title: 'Editar' do %>
                          <i class="dripicons-document-edit"></i>
                        <% end %>
                      </td>
                      <td>
                        <%= button_to [:admin, #{model_name}], method: :delete, class: 'btn btn-danger delete-button', formaction: admin_#{model_name}_path(#{model_name}), id: "deleteButton-\#{#{model_name}.id}", title: 'Deletar' do %>
                          <i class="dripicons-document-delete"></i>
                        <% end %>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
            <br>
            <%= link_to new_admin_#{model_name}_path, class: 'btn btn-info' do %>
             <i class="typcn typcn-document-add"></i> Adicionar
            <% end %>
            <!-- Paginação -->
            <div class="d-flex justify-content-center">
              <%= paginate @#{pluralize(model_name)}, theme: :admin, paginator: 'kaminari/admin/paginator', paginated_collection: @#{pluralize(model_name)} %>#{'             '}
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- end row -->
  HTML

  # Salvar o arquivo ERB modificado
  File.write(file_path, updated_index)

  # Atualizar a controller para usar paginação e busca
  model_name_capitalize = model_name.split('_').map(&:capitalize).join
  controller_path = File.join('app/controllers/admin', "#{pluralize(model_name)}_controller.rb")
  if File.exist?(controller_path)
    controller_content = File.read(controller_path)
    paginated_content = controller_content.sub(
      /@#{pluralize(model_name)} = .*\.all/,
      <<~RUBY
        if params[:query].present?
          query = params[:query].downcase
          @#{pluralize(model_name)} = #{model_name_capitalize}.where(build_search_query(#{model_name_capitalize}, query)).order(id: :desc).page(params[:page]).per(10)
        else
          @#{pluralize(model_name)} = #{model_name_capitalize}.order(id: :desc).page(params[:page]).per(10)
        end
      RUBY
    )

    paginated_content.gsub!(/redirect_to \[:admin, @#{model_name}\], notice: .*$/,
                            "redirect_to [:admin, @#{model_name}], notice: 'Criado com sucesso!'")
    paginated_content.gsub!(/redirect_to \[:admin, @#{model_name}\], notice: .*$/,
                            "redirect_to [:admin, @#{model_name}], notice: 'Salvo com sucesso!'")
    paginated_content.gsub!(/redirect_to admin_#{pluralize(model_name)}_url, notice: .*$/,
                            "redirect_to admin_#{pluralize(model_name)}_url, notice: 'Deletado com sucesso!'")

    paginated_content += "\nprivate\n\n" unless controller_content.include?("private\n")
    unless controller_content.include?('def build_search_query')
      paginated_content += <<~RUBY

        def build_search_query(model, query)
          columns = model.column_names
          search_conditions = columns.map { |column| "LOWER(CAST(\#{column} AS TEXT)) LIKE :query" }.join(' OR ')
          [search_conditions, query: "%\#{query}%"]
        end
      RUBY
    end
    File.write(controller_path, paginated_content)
    puts "Controller atualizado com paginação e busca: #{controller_path}"
  else
    puts "Controller não encontrado: #{controller_path}"
  end
end

# Caminho do arquivo de index gerado pelo scaffold
index_file_path = ARGV[0]
model_name = ARGV[1]
column_names = ARGV[2..]

if File.exist?(index_file_path)
  style_index_table(index_file_path, model_name, column_names)
  puts "Estilos adicionados com sucesso à index: #{index_file_path}"
else
  puts "Arquivo de index não encontrado: #{index_file_path}"
end
