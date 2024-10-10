# frozen_string_literal: true

module CertificateHelper
  require 'openssl'

  def process_pfx_file
    return unless certificate.present? && temp_password.present?
  
    begin
      pfx_path = certificate.path
      pfx_data = File.read(pfx_path)
      pkcs12 = OpenSSL::PKCS12.new(pfx_data, temp_password)
      @certificate = pkcs12.certificate
      @private_key = pkcs12.key
      extract_certificate_info(@certificate)
    rescue OpenSSL::PKCS12::PKCS12Error
      errors.add(:base, 'Senha incorreta ou arquivo PFX inválido')
      raise ActiveRecord::RecordInvalid, self
    end
  end
  
  def extract_certificate_info(certificate)
    subject = certificate.subject.to_s
    self.responsavel_cpf = subject[/serialNumber=(\d+)/, 1]
    self.responsavel_nome = subject[/CN=([^,]+?)(?:,\s?serialNumber=|\z)/, 1]
  end
end
