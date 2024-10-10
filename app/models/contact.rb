# frozen_string_literal: true

class Contact < ApplicationRecord
  validates :name, :email, :message, :subject, presence: true
end
