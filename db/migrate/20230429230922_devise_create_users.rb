# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # Others attributes
      t.string :name, null: false
      t.string :slug
      t.string :avatar
      t.string :cpf
      t.string :rg
      t.date :date_birth
      t.integer :sex
      t.string :functional_registration
      t.string :cep
      t.string :uf
      t.string :city
      t.string :street
      t.string :neighborhood
      t.string :number_address
      t.string :complement
      t.string :phone
      t.integer :logged
      # user type
      t.boolean :super_user, default: false
      t.boolean :admin_user, default: false
      t.boolean :common_user, default: false
      # permission
      t.boolean :register, default: false
      t.boolean :read, default: false
      t.boolean :publish, default: false
      t.boolean :status, default: true

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
