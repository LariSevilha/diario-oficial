# frozen_string_literal: true

class Entity < ApplicationRecord
  belongs_to :type_entity
  belongs_to :user
  has_many :official_diarys
  has_and_belongs_to_many :users, join_table: :entitys_users

  mount_uploader :logo, EntityUploader
  validates :cnpj, :name_entity, :uf, :city, :cep, :law, :name_diary, :logo, presence: true

  extend FriendlyId
  friendly_id :name_entity, use: :slugged
end
