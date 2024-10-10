# frozen_string_literal: true

class ContactMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM_MAIL']

  def send_mailer(contact)
    @contact = contact

    mail(
      to: ENV['SMTP_FROM_MAIL'],
      from: ENV['SMTP_USER_NAME'],
      subject: 'Formulário de contato'
    )
  end
end
