# verifySignature: function(timestamp, token, signature, minutes_offset) {
#   var offset = Math.round((new Date()).getTime() / 1000) - (minutes_offset || 5) * 60;
#   if(timestamp < offset)
#     return false;
#     
#   var hmac = crypto.createHmac('sha256', api_key);
#   hmac.update(timestamp + token);
#   return signature == hmac.digest('hex');
# },

module Mailgun
  class Secure
    def initialize(mailgun)
      @mailgun = mailgun
    end
    
    # check request auth
    def check_request_auth(timestamp, token, signature, offset=-5)
      if offset != 0
        offset = Time.now.to_i + offset * 60
        return false if timestamp < offset
      end
      
      return signature == OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest::Digest.new('sha256'),
        Mailgun.api_key,
        '%s%s' % [timestamp, token])
    end
  end
end
