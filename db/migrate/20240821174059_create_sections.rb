# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string :title
      t.text :description
      t.integer :content_type, default: 0
      t.references :branch_government, null: false, foreign_key: true
      t.references :diary_category, null: false, foreign_key: true
      t.references :diary_sub_category, null: true, foreign_key: true
      t.references :official_diary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
