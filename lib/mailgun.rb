require "rest-client"
require "json"
require "multimap"

require "mailgun/mailgun_error"
require "mailgun/base"
require "mailgun/route"
require "mailgun/mailbox"
require "mailgun/mail"
require "mailgun/bounce"
require "mailgun/unsubscribe"
require "mailgun/complaint"
require "mailgun/log"
require "mailgun/list"
require "mailgun/list/member"

#require "startup"

def Mailgun(options={})
  options[:api_key] = Mailgun.api_key if Mailgun.api_key
  Mailgun::Base.new(options)
end
