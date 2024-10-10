# frozen_string_literal: true

module Admin
  class FileSectionsController < ApplicationController
    def destroy
      file_section = FileSection.find(params[:id])
      if file_section.destroy
        render json: { success: true }
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    end
  end
end
