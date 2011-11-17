require "rest-client"
require "json"

require 'mailgun/base'
require 'mailgun/mailbox'

def Mailgun(options)
  Mailgun::Base.new(options)
end
