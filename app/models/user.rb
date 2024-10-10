# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :office
  has_many :entitys, dependent: :destroy
  has_and_belongs_to_many :entitys, join_table: :entitys_users

  validates :name, :cpf, :sex, :cep, :uf, :city, :street, :neighborhood, presence: true

  # Conditional password validation
  validates :password, presence: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, AvatarUploader

  enum sex: {
    "Não informado": 0,
    "Masculino": 1,
    "Feminino": 2,
    "Outro": 3
  }

  def entity_ids
    entitys.pluck(:id)
  end

  def diary_category_ids
    DiaryCategory.joins(:entity).where(entity: { id: entity_ids }).pluck(:id)
  end

  private

  # Method to check whether password is required
  def password_required?
    !persisted? || !password.blank?
  end
end
