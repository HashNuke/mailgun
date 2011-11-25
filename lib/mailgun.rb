require "rest-client"
require "json"

require "mailgun/mailgun_error"
require "mailgun/base"
require "mailgun/route"
require "mailgun/mailbox"

def Mailgun(options={})
  Mailgun::Base.new(options)
end
