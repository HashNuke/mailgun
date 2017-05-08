module Mailgun
  class Error
    def self.from_client_error(client_error)
      error_code = client_error.http_code

      error_message = begin
        JSON(client_error.http_body)["message"]
      rescue JSON::ParserError
        ''
      end

      get_class_for_code(error_code).new(error_message)
    end

    def self.get_class_for_code(code)
      case code
      when 404
        Mailgun::NotFound
      when 400
        Mailgun::BadRequest
      when 401
        Mailgun::Unauthorized
      when 402
        Mailgun::ResquestFailed
      when 500, 502, 503, 504
        Mailgun::ServerError
      else
        Mailgun::ErrorBase
      end
    end
  end

  class ErrorBase < StandardError ; end

  class NotFound < ErrorBase ; end

  class BadRequest < ErrorBase ; end

  class Unauthorized < ErrorBase ; end

  class ResquestFailed < ErrorBase ; end

  class ServerError < ErrorBase ; end
end
