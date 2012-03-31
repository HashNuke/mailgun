

Mailgun
=========
This gem allows for idiomatic Mailgun usage from within ruby. Mailgun is a kickass email-as-a-service that lets you use email as if it made sense. Check it out at http://mailgun.net/

The official gem repo is at https://github.com/Bushido/mailgun

Mailgun exposes the following resources:

  * Routes
  * Log
  * Stats
  * Messages
  * Mailboxes
  * Bounces
  * Unsubscribes
  * Complaints

Currently the gem only exposes the Mailbox and Routes APIs, but patches are welcome (and easy!). 

Usage
=====
We mimic the ActiveRecord-style interface.

Mailboxes:

    # Initialize your Mailgun object:
    Mailgun.configure do |config|
      config.api_key = 'your-api-key'
      config.domain  = 'your-mailgun-domain'
    end

    @mailgun = Mailgun()

    # or alternatively:
    @mailgun = Mailgun(:api_key => 'your-api-key')
    
    # Create a mailbox
    @mailgun.mailboxes.create "new-mailbox@your-domain.com", "password"
    
    # List all mailboxes that belong to a domain
    @mailgun.mailboxes.list "domain.com"
    
    # Destroy a mailbox (queue bond-villian laughter)
    # "I'm sorry Bond, it seems your mailbox will be... destroyed!"
    @mailbox.mailboxes.destroy "bond@mi6.co.uk"
    
Routes:

    # Initialize your Mailgun object:
    @mailgun = Mailgun(:api_key => 'your-api-key')

    # Create a route
    # Give it a human-readable description for later, a priority
    # filters, and actions
    @mailgun.routes.create "Description for the new route", 1,
         [:match_recipient, "apowers@mi5.co.uk"],
         [[:forward, "http://my-site.com/incoming-mail-route"],
          [:stop]]
    
    # List all routes that belong to a domain
    # limit the query to 100 routes starting from 0
    @mailgun.routes.list 100, 0

    # Get the details of a route via its id
    @mailgun.routes.find "4e97c1b2ba8a48567f007fb6"

    # Update a route via its id
    # (all keys are optional)
    @mailgun.routes.update "4e97c1b2ba8a48567f007fb6", {
         :priority => 2,
         :filter   => [:match_header, :subject, "*.support"],
         :actions  => [[:forward, "http://new-site.com/incoming-emails"]]
         }
    
    # Destroy a route via its id
    @mailbox.routes.destroy "4e97c1b2ba8a48567f007fb6"

Supported route filters are: `:match_header`, `:match_recipient`, and `:catch_all`
Supported route actions are: `:forward`, and `:stop`


Making Your Changes
===================

  * Fork the project (Github has really good step-by-step directions)
  * Start a feature/bugfix branch
  * Commit and push until you are happy with your contribution
  * Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
  * After making your changes, be sure to run the Mailgun RSpec specs to make sure everything works.
  * Submit your change as a Pull Request and update the GitHub issue to let us know it is ready for review.


TODO
=========

  * Mailgun() is overwriting api key. api key is not persisting
  * Add skip and limit functionality
  * Distinguish failed in logs
  * Distinguish delivered in logs
  * Mailing Lists
  * Tracking?
  * Stats?
  * Campaign?

Authors
=======

  * Akash Manohar J (akash@akash.im)
  * Sean Grove (sean@gobushido.com)

Thanks
======
Huge thanks to the Mailgun guys for such an amazing service! No time spent on mailservers == way more time spent drinking!

License & Copyright
===================
Released under the MIT license. See LICENSE for more details.

All copyright Bushido Inc. 2011
