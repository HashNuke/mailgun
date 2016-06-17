module Mailgun
  class Client
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def get(params = {})
      request_path = path
      request_path += "?#{URI.encode_www_form(params)}" if params.any?

      request = Net::HTTP::Get.new(request_path)

      make_request(request)
    end

    def post(params = {})
      request = Net::HTTP::Post.new(path)
      request.set_form_data(params)

      make_request(request)
    end

    def put(params = {})
      request = Net::HTTP::Put.new(path)
      request.set_form_data(params)

      make_request(request)
    end

    def delete(params = {})
      request = Net::HTTP::Delete.new(path)
      request.set_form_data(params)

      make_request(request)
    end

    private

    def make_request(request)
      set_auth(request)
      response = http_client.request(request)

      check_for_errors(response)

      response.body
    end

    def check_for_errors(response)
      return if response.code == '200'

      error = ClientError.new
      error.http_code = response.code.to_i
      error.http_body = response.body
      raise error
    end

    def path
      parsed_url.path
    end

    def parsed_url
      @parsed_url ||= URI.parse url
    end

    def http_client
      http = Net::HTTP.new(mailgun_url.host, mailgun_url.port)
      http.use_ssl = true
      http
    end

    def mailgun_url
      URI.parse Mailgun().base_url
    end

    def set_auth(request)
      request.basic_auth(parsed_url.user, parsed_url.password)
    end
  end
end

module Mailgun
  class ClientError < StandardError
    attr_accessor :http_code, :http_body
  end
end
