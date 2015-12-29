module Mailgun
  class Error
    attr_accessor :error

    def initialize(options={})
      @error =
        case options[:code]
        when 200
          # Not an error
        when 404
          Mailgun::NotFound.new(options[:message])
        when 400
          Mailgun::BadRequest.new(options[:message])
        when 401
          Mailgun::Unauthorized.new(options[:message])
        when 402
          Mailgun::ResquestFailed.new(options[:message])
        when 500, 502, 503, 504
          Mailgun::ServerError.new(options[:message])
        else
          Mailgun::ErrorBase.new(options[:message])
        end
    end

    def handle
      return error.handle
    end
  end

  class ErrorBase < StandardError
    # Handles the error if needed
    # by default returns an error
    #
    # @return [type] [description]
    def handle
      return self
    end
  end

  class NotFound < ErrorBase
    def handle
      return nil
    end
  end

  class BadRequest < ErrorBase
  end

  class Unauthorized < ErrorBase
  end

  class ResquestFailed < ErrorBase
  end
end
