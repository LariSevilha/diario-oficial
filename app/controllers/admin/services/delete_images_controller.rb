# frozen_string_literal: true

# app/controllers/admin/services/delete_images_controller.rb
module Admin
  module Services
    class DeleteImagesController < ApplicationController
      def remove_image
        model_name, attribute = params[:model_attribute].split('-')
        model_class = model_name.camelize.constantize
        model = model_class.find(params[:id])

        model.send("remove_#{attribute}!")
        model.save!
        render json: { success: true }
      end
    end
  end
end
