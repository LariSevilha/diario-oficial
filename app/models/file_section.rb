# frozen_string_literal: true

class FileSection < ApplicationRecord
  belongs_to :section
  mount_uploader :file, ArchiveUploader
end
