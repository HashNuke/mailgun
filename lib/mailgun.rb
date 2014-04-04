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
require "mailgun/complaint"
require "mailgun/log"
require "mailgun/list"
require "mailgun/list/member"
require "mailgun/message"

#require "startup"

def Mailgun(options={})
  options[:api_key] = Mailgun.api_key if Mailgun.api_key
  options[:domain] = Mailgun.domain if Mailgun.domain
  Mailgun::Base.new(options)
end
