# frozen_string_literal: true

class CreateEntitysUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :entitys do |t|
      t.index :user_id
      t.index :entity_id
    end

    add_foreign_key :entitys_users, :users
    add_foreign_key :entitys_users, :entitys
  end
end
