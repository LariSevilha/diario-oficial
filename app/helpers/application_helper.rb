# frozen_string_literal: true

module ApplicationHelper
  # Dinamic adsense script variables
  def ads_head
    @head_ads = Adsense.where(ad_type: 0).where(status: true)
    @head_ads
  end

  def ads_body
    @body_ads = Adsense.where(ad_type: 1).where(status: true)
    @body_ads
  end

  def ads_footer
    @footer_ads = Adsense.where(ad_type: 2).where(status: true)
    @footer_ads
  end

  def bootstrap_class_for(flash_type)
    case flash_type
    when 'notice'
      'success'
    when 'alert'
      'warning'
    when 'error'
      'danger'
    else
      flash_type.to_s
    end
  end

  def flash_message_header(flash_type)
    case flash_type
    when 'notice'
      'Bem feito!'
    when 'alert'
      'Atenção!'
    when 'error'
      'Oh não!'
    else
      'Aviso'
    end
  end

  def format_date(date_param)
    return unless date_param.present?

    date_param.strftime('%d/%m/%Y')
  end

  def boolean_format(boolean_param)
    boolean_param ? 'sim' : 'não'
  end

  # Method to define which tab should be active based on user type
  def active_user_tab(user)
    if user.super_user?
      'super-user'
    elsif user.admin_user?
      'user-admin'
    else
      'common-user'
    end
  end

  # Method to check whether a tab should only be displayed during editing
  def show_user_tab?(user, tab)
    return true if user.new_record?

    case tab
    when 'super-user'
      user.super_user?
    when 'user-admin'
      user.admin_user?
    when 'common-user'
      user.common_user?
    else
      false
    end
  end

  # Method to check whether a specific field should be displayed based on user type
  def show_user_field?(user, field)
    return true if user.new_record?

    case field
    when :super_user
      user.super_user?
    when :admin_user
      user.admin_user?
    when :common_user
      user.common_user?
    when :permissions
      user.common_user?
    else
      false
    end
  end
end
