# frozen_string_literal: true

class CreateFileSections < ActiveRecord::Migration[7.0]
  def change
    create_table :file_sections do |t|
      t.string :file
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
