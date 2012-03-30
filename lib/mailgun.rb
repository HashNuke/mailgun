require "rest-client"
require "json"
require "multimap"

require "mailgun/mailgun_error"
require "mailgun/base"
require "mailgun/route"
require "mailgun/mailbox"
require "mailgun/bounce"

def Mailgun(options={})
  Mailgun::Base.new(options)
end
