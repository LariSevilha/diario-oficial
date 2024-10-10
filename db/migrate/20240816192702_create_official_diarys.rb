# frozen_string_literal: true

class CreateOfficialDiarys < ActiveRecord::Migration[7.0]
  def change
    create_table :official_diarys do |t|
      t.integer :edition
      t.string :slug
      t.string :certificate
      t.string :combined_file
      t.boolean :published, :default => false     
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
