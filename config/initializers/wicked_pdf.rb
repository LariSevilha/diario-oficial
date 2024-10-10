# frozen_string_literal: true

WickedPdf.config ||= {}
WickedPdf.config.merge!({
                          exe_path: '/usr/local/bin/wkhtmltopdf' # Ajuste o caminho conforme necessário
                        })
