# frozen_string_literal: true

class ContactsController < ApplicationController
  def index
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if verify_recaptcha(model: @contact)
      if valid_fields(@contact).errors.empty?
        if EmailValidator.valid?(contact_params[:email])
          if @contact.save
            send_mail
          else
            flash[:error] = 'Erro ao enviar e-mail, tente novamente'
            redirect_to root_path
          end
        else
          flash[:error] = 'O formato do email é inválido'
          redirect_to root_path
        end
      else
        redirect_to root_path
      end
    else
      flash[:error] = 'reCaptcha Inválido.'
      redirect_to root_path
    end
  end

  def send_mail
    contact = contact_params
    contact['request'] = request.base_url
    contact_params = contact

    if ContactMailer.send_mailer(contact_params).deliver_now
      redirect_to contact_path, flash: {
        notice: 'Seus dados foram enviados com sucesso.'
      }
    else
      flash[:error] = 'Falhou. Tente novamente'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :name, :email, :phone, :subject, :message
    )
  end

  def valid_fields(i)
    i.attributes.each do |attribute, value|
      if (attribute != 'id' && attribute != 'created_at' && attribute != 'updated_at') &&
         (value == '' || value == ' ' || value.nil? || !value.present?)
        i.errors.add(attribute, 'não pode ficar vazio.')
      end
    end
    i
  end
end
