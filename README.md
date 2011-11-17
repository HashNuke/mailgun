Mailgun
=========


	# create a mailbox object
	mailgun = Mailgun.new :api_key
	
	# create a mailbox
	mailgun.create_mailbox :name => "product_support@nice-guy.com",
						   :password => "password"
	
	# list mailboxes
	mailgun.list_mailboxes "product_support"

	# delete a mailbox
	mailbox.delete_mailbox :mailbox => "product_support@nice-guy.com"