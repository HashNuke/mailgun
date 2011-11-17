Mailgun
=========


	# create a mailbox object
	mailgun = Mailgun.new :api_key => "something-thing"
	
	# create a mailbox
	mailgun.create_mailbox :name => "product_support",
												 :domain => nice-guy.com",
						   					 :password => "password"
	
	# list mailboxes
	mailgun.list_mailboxes :domain => "product_support"

	# delete a mailbox
	mailbox.delete_mailbox :name => "product_support", :domain => "nice-guy.com"