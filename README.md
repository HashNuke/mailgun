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

Currently the gem only exposes the Mailbox API, but patches are welcome (and easy!). 

Usage
=====
We mimic the ActiveRecord-style interface.

    # Initialize your Mailgun object:
    Mailgun.configure do |config|
      config.api_key = 'your-api-key'
    end

    @mailgun = Mailgun()

    # or alternatively use can do:
    @mailgun = Mailgun(:api_key => 'your-api-key')
    
    # Create a mailbox
    @mailgun.mailbox.create "new-mailbox@your-domain.com", "password"
    
    # List all mailboxes that belong to a domain
    @mailgun.mailboxes.list "domain.com"
    
    # Destroy a mailbox (queue bond-villian laughter)
    # "I'm sorry Bond, it seems your mailbox will be... destroyed!"
    @mailbox.mailboxes.destroy "bond@mi5.co.uk"

Making Your Changes
===================

  * Fork the project (Github has really good step-by-step directions)
  * Start a feature/bugfix branch
  * Commit and push until you are happy with your contribution
  * Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
  * After making your changes, be sure to run the Mailgun RSpec specs to make sure everything works.
  * Submit your change as a Pull Request and update the GitHub issue to let us know it is ready for review.

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
