# frozen_string_literal: true

class AddCombinedPdfToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :combined_pdf, :string
  end
end
