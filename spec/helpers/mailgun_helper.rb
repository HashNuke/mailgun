module MailgunHelper
  def generate_request_auth(api_key, offset=0)
    timestamp = Time.now.to_i + offset * 60
    token = ([nil]*50).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), api_key, '%s%s' % [timestamp, token])
        
    return timestamp, token, signature
  end
end