# frozen_string_literal: true

class CreateDiarySubCategorys < ActiveRecord::Migration[7.0]
  def change
    create_table :diary_sub_categorys do |t|
      t.string :name
      t.references :diary_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
