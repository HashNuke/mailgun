require "rest-client"
require "json"
require "multimap/lib/multimap"
require "multimap/lib/multiset"
require "multimap/lib/nested_multimap"

require "mailgun/mailgun_error"
require "mailgun/base"
require "mailgun/domain"
require "mailgun/route"
require "mailgun/mailbox"
require "mailgun/bounce"
require "mailgun/unsubscribe"
require "mailgun/webhook"
require "mailgun/complaint"
require "mailgun/log"
require "mailgun/list"
require "mailgun/list/member"
require "mailgun/message"
require "mailgun/secure"
require "mailgun/validation"

#require "startup"

def Mailgun(options={})
  options[:api_key]               = Mailgun.api_key               if Mailgun.api_key
  options[:domain]                = Mailgun.domain                if Mailgun.domain
  options[:api_pub_key]           = Mailgun.api_pub_key           if Mailgun.api_pub_key
  options[:mailgun_webhook_url]   = Mailgun.mailgun_webhook_url   if Mailgun.mailgun_webhook_url
  options[:mailgun_url]           = Mailgun.mailgun_url           if Mailgun.mailgun_url
  options[:mailgun_authorization] = Mailgun.mailgun_authorization if Mailgun.mailgun_authorization
  Mailgun::Base.new(options)
end
