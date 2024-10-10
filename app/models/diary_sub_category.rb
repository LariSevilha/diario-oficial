# frozen_string_literal: true

class DiarySubCategory < ApplicationRecord
  belongs_to :diary_category
  has_many :sections
end
