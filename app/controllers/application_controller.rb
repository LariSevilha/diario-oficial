# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :page_info
  before_action :authenticate_user!, if: :admin_namespace?

  def page_info
    set_meta_tags(
      site: 'Diário oficial',
      title: 'Página de Início'
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'logo-top.svg')
    return unless File.exist?(image_path)

    set_meta_tags image_src: ActionController::Base.helpers.asset_path('logo-top.svg')
  end

  private

  def admin_namespace?
    request.path.start_with?('/admin')
  end

  protected

  def after_sign_in_path_for(_resource)
    admin_root_path
  end
end
