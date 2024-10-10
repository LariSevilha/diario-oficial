# frozen_string_literal: true

class DiaryCategory < ApplicationRecord
  has_many :diary_sub_categorys
  has_many :sections
end
