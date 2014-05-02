require 'spec_helper'

describe Mailgun::Event do

  let(:events_list_response) do
    {
      "items" => [
      {
        "campaigns" => [],
        "user-variables" => {},
        "flags" => {
           "is-test-mode" => false
        },
        "tags" =>  [],
        "timestamp" => 1378335036.859382,
        "message" =>  {
           "headers" =>  {
              "to" => "satshabad <satshabad@mailgun.com>",
              "message-id" => "CAC8xyJxAO7Y0sr=3r-rJ4C6ULZs3cSVPPqYEXLHtarKOKaOCKw@mail.gmail.com",
              "from" => "Someone <someone@example.com>",
              "subject" => "Re: A TEST"
           },
           "attachments" => [],
           "recipients" => [
              "satshabad@mailgun.com"
           ],
           "size" => 2566
        },
        "storage" => {
          "url" => "https://api.mailgun.net/v2/domains/ninomail.com/messages/WyI3MDhjODgwZTZlIiwgIjF6",
          "key" => "WyI3MDhjODgwZTZlIiwgIjF6"
        },
        "event" => "stored"
      }
     ],
      "paging" => {
        "next" => "https://api.mailgun.net/v2/samples.mailgun.org/events/W3siY...",
        "previous" => "https://api.mailgun.net/v2/samples.mailgun.org/events/Lkawm..."
      }
    }
  end
  let(:options) do
    {
      :end   => Time.parse('Wed, 15 Feb 2012 13:03:31 +0100'),
      :event   => :stored
    }
  end


  before :each do
    allow( Mailgun ).to receive(:submit).and_return(events_list_response)
    @mailgun = Mailgun({:api_key => "your_api_key"})
  end

  describe '#list' do
    it 'make a GET request with the given params' do
      expect(Mailgun).to receive(:submit).
        with(:get, @mailgun.events.send('events_url'), options)

      @mailgun.events.list options
    end

    it 'returns a Mailgun::Event object' do
      expect(@mailgun.events.list(options).class).to eql(Mailgun::Event)
    end

    it 'assigns items mailgun events under items' do
      event = @mailgun.events.list(options)

      expect(event.items).to eql(events_list_response['items'])
    end

    it 'assigns items mailgun pagination info under page' do
      event = @mailgun.events.list(options)

      expect(event.page).to eql(events_list_response['paging'])
    end

    context 'validating params' do

      it 'raises argument error if event is not a symbol param is worng' do
        wrong_options = options.merge(event: 'no_event')

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'raises argument error if event is not one of the valid events' do
        wrong_options = options.merge(event: :no_event)

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'raises argument error if end is not a Time object' do
        wrong_options = options.merge(end: 'Wed, 15 Feb 2012 13:03:31 +0100')

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'raises argument error if begin is not a Time object' do
        wrong_options = options.merge(begin: 'Wed, 15 Feb 2012 13:03:31 +0100')

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'raises argument error if begin is not a Time object' do
        wrong_options = options.merge(begin: 'Wed, 15 Feb 2012 13:03:31 +0100')

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'raises argument error if ascending is not a Boolean' do
        wrong_options = options.merge(ascending: 'true')

        expect{ @mailgun.events.list wrong_options }.to raise_error(ArgumentError)
      end

      it 'transforms time objects to RFC 2822' do
        expect(Mailgun).to receive(:submit) { |action, url, options|
          expect(options[:end]).to eql('Wed, 15 Feb 2012 13:03:31 +0100')
        }.and_return(events_list_response)

        @mailgun.events.list options
      end

    end
  end

  describe '#page' do
    it 'returns the pagination info returned by mailgun' do
      event = @mailgun.events.list(options)

      expect(event.page).to eql(events_list_response['paging'])
    end

    it 'returns empty hash if no pagination returned by mailgun' do
      allow( Mailgun ).to receive(:submit).and_return(events_list_response.merge('paging' =>  nil))

      event = @mailgun.events.list(options)

      expect(event.page).to eql({})
    end
  end

  describe '#next?' do
    it 'returns true if there is a next page returned by mailgun' do
      event = @mailgun.events.list(options)

      expect(event.next?).to be_true
    end

    it 'returns false if there is no next page returned by mailgun' do
      allow( Mailgun ).to receive(:submit).and_return(events_list_response.merge('paging' => nil ))

      event = @mailgun.events.list(options)

      expect(event.next?).to be_false
    end

    it 'returns false if no pagination returned by mailgun' do
      allow( Mailgun ).to receive(:submit).and_return(events_list_response.merge('paging' => { 'previous' => 'url' }))

      event = @mailgun.events.list(options)

      expect(event.next?).to be_false
    end
  end

  describe '#prev?' do
    it 'returns true if there is a previous page returned by mailgun' do
      event = @mailgun.events.list(options)

      expect(event.prev?).to be_true
    end

    it 'returns false if there is no previous page returned by mailgun' do
      allow( Mailgun ).to receive(:submit).and_return(events_list_response.merge('paging' => nil ))

      event = @mailgun.events.list(options)

      expect(event.prev?).to be_false
    end

    it 'returns false if no pagination returned by mailgun' do
      allow( Mailgun ).to receive(:submit).and_return(events_list_response.merge('paging' => { 'next' => 'url' }))

      event = @mailgun.events.list(options)

      expect(event.prev?).to be_false
    end
  end

  describe '#next' do
    it 'returns a new Mailgun::Event object' do
      event = @mailgun.events.list(options)

      expect(event.next.class).to eql(Mailgun::Event)
      expect(event.next).to_not eql(event)
    end

    it 'calls to the same action with the new url and the same options' do
      event = @mailgun.events.list(options)

      expect( Mailgun ).to receive(:submit) { |action, url, options|
        expect(url).to eql( event.page['next'] )
        expect(options).to eql(options)
      }.and_return( events_list_response )

      event.next
    end

    it 'does not call to mailgun if the is no next page' do
      event = @mailgun.events.list(options)
      allow(event).to receive(:next?).and_return(false)

      expect( Mailgun ).to_not receive(:submit)

      next_event = event.next
      expect(next_event).to be_nil
    end
  end

  describe '#prev' do
    it 'returns a new Mailgun::Event object' do
      event = @mailgun.events.list(options)

      expect(event.prev.class).to eql(Mailgun::Event)
      expect(event.prev).to_not eql(event)
    end

    it 'calls to the same action with the new url and the same options' do
      event = @mailgun.events.list(options)

      expect( Mailgun ).to receive(:submit) { |action, url, options|
        expect(url).to eql( event.page['previous'] )
        expect(options).to eql(options)
      }.and_return( events_list_response )

      event.prev
    end

    it 'does not call to mailgun if the is no prev page' do
      event = @mailgun.events.list(options)
      allow(event).to receive(:prev?).and_return(false)

      expect( Mailgun ).to_not receive(:submit)

      prev_event = event.prev
      expect(prev_event).to be_nil
    end
  end


end
