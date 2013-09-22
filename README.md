# Mailgun rubygem

This gem allows for idiomatic Mailgun usage from within ruby. Mailgun is a kickass email-as-a-service that lets you use email as if it made sense. Check it out at http://mailgun.net

Mailgun exposes the following resources:

  * Sending email
  * Mailing Lists
  * Mailing List Members
  * Mailboxes
  * Routes
  * Log
  * Stats
  * Messages
  * Bounces
  * Unsubscribes
  * Complaints
  * Domain management

Patches are welcome (and easy!).

## Sending mail using ActionMailer

If you simply want to send mail using Mailgun, just set the smtp settings in the Rails application like the following. Replace wherever necessary in the following snippet :)
```ruby
ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => 'smtp.mailgun.org',
  :user_name      => 'postmaster@your.mailgun.domain',
  :password       => 'mailgun-smtp-password',
  :domain         => 'your.mailgun.domain',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp
```

## Usage

We mimic the ActiveRecord-style interface.


#### Configuration
```ruby
# Initialize your Mailgun object:
Mailgun.configure do |config|
  config.api_key = 'your-api-key'
  config.domain  = 'your-mailgun-domain'
end

@mailgun = Mailgun()

# or alternatively:
@mailgun = Mailgun(:api_key => 'your-api-key')
```

#### Sending Email
```ruby
parameters = {
  :to => "cooldev@your.mailgun.domain",
  :subject => "missing tps reports",
  :text => "yeah, we're gonna need you to come in on friday...yeah.",
  :from => "lumberg.bill@initech.mailgun.domain"
}
@mailgun.messages.send_email(parameters)
```
####

#### Mailing Lists
```ruby
# Create a mailing list
@mailgun.lists.create "devs@your.mailgun.domain"

# List all Mailing lists
@mailgun.lists.list

# Find a mailing list
@mailgun.lists.find "devs@your.mailgun.domain"

# Update a mailing list
@mailgun.lists.update("devs@your.mailgun.domain", "developers@your.mailgun.domain", "Developers", "Develepor Mailing List")

# Delete a mailing list
@mailgun.lists.delete("developers@your.mailgun.domain")
```

#### Mailing List Members
```ruby
# List all members within a mailing list
@mailgun.list_members.list "devs@your.mailgun.domain"

# Find a particular member in a list
@mailgun.list_members.find "devs@your.mailgun.domain", "bond@mi6.co.uk"

# Add a member to a list
@mailgun.list_members.add "devs@your.mailgun.domain", "Q@mi6.co.uk"

# Update a member on a list
@mailgun.list_members.update "devs@your.mailgun.domain", "Q@mi6.co.uk", "Q", {:gender => 'male'}.to_json, :subscribed => 'no')

# Remove a member from a list
@mailgun.list_members.remove "devs@your.mailgun.domain", "M@mi6.co.uk"
```

#### Mailboxes
```ruby
# Create a mailbox
@mailgun.mailboxes.create "new-mailbox@your-domain.com", "password"

# List all mailboxes that belong to a domain
@mailgun.mailboxes.list "domain.com"

# Destroy a mailbox (queue bond-villian laughter)
# "I'm sorry Bond, it seems your mailbox will be... destroyed!"
@mailbox.mailboxes.destroy "bond@mi6.co.uk"
```

#### Bounces
```ruby
# List last bounces (100 limit)
@mailgun.bounces.list

# Find bounces
@mailgun.bounces.find "user@ema.il"

# Add bounce
@maligun.bounces.add "user@ema.il"

# Clean user bounces
@mailbox.bounces.destroy "user@ema.il"
```

#### Routes
```ruby
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
     :priority   => 2,
     :expression => [:match_header, :subject, "*.support"],
     :actions    => [[:forward, "http://new-site.com/incoming-emails"]]
     }

# Destroy a route via its id
@mailbox.routes.destroy "4e97c1b2ba8a48567f007fb6"
```

Supported route filters are: `:match_header`, `:match_recipient`, and `:catch_all`

Supported route actions are: `:forward`, and `:stop`


#### Domains
```ruby
# Add a domain
@mailgun.domains.create "example.com"

# List all domains that belong to the account
@mailgun.domains.list

# Get info for a domain
@mailgun.domains.find "example.com"

# Remove a domain
@mailbox.domains.delete "example.com"
```

## Making Your Changes

  * Fork the project (Github has really good step-by-step directions)

  * Start a feature/bugfix branch

  * Commit and push until you are happy with your contribution

  * Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.

  * After making your changes, be sure to run the Mailgun tests using the `rspec spec` to make sure everything works.

  * Submit your change as a Pull Request and update the GitHub issue to let us know it is ready for review.




## TODO

  * Add skip and limit functionality
  * Distinguish failed in logs
  * Distinguish delivered in logs
  * Tracking?
  * Stats?
  * Campaign?


## Maintainer

Akash Manohar / [@HashNuke](http://github.com/HashNuke)


## Authors

* Akash Manohar / [@HashNuke](http://github.com/HashNuke)
* Sean Grove / [@sgrove](http://github.com/sgrove)

See CONTRIBUTORS.md file for contributor credits.

## License

Released under the MIT license. See LICENSE for more details.
