# frozen_string_literal: true

class CreateEntitys < ActiveRecord::Migration[7.0]
  def change
    create_table :entitys do |t|
      t.string :cnpj
      t.string :phone
      t.references :type_entity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name_entity
      t.string :uf
      t.string :city
      t.string :cep
      t.string :street
      t.string :number_address
      t.string :complement
      t.string :slug
      t.string :law
      t.string :name_diary
      t.string :logo
      t.boolean :status
      t.integer :number_edition
      t.text :diary_content

      t.timestamps
    end
  end
end
