# frozen_string_literal: true

class Office < ApplicationRecord
  has_many :users
  validates :name, presence: true
end
