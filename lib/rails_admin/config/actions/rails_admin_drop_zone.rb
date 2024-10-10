# frozen_string_literal: true

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsDropZone
end

module RailsAdmin
  module Config
    module Actions
      class DropZone < Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'fa fa-upload'
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          proc do
            @album = @abstract_model.model.find(params[:id])

            redirect_to "/galerias/#{@album.slug}/adicionar-foto"
          end
        end
      end
    end
  end
end
