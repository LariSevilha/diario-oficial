# frozen_string_literal: true

class CreateTypeEntitys < ActiveRecord::Migration[7.0]
  def change
    create_table :type_entitys do |t|
      t.string :name

      t.timestamps
    end
  end
end
