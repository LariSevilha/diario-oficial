# frozen_string_literal: true

class CreateDiaryCategorys < ActiveRecord::Migration[7.0]
  def change
    create_table :diary_categorys do |t|
      t.string :name

      t.timestamps
    end
  end
end
