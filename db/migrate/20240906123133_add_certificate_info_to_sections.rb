# frozen_string_literal: true

class AddCertificateInfoToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :responsavel_nome, :string
    add_column :sections, :responsavel_cpf, :string
  end
end
