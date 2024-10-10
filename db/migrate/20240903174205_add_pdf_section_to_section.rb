# frozen_string_literal: true

class AddPdfSectionToSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :pdf_section, :string
  end
end
