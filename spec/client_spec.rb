require 'spec_helper'

require 'webmock/rspec'

describe Mailgun::Client do
  subject { described_class.new(url) }

  describe '#get' do
    context 'without query params' do
      let(:url) { 'https://api:key@api.mailgun.net/v3/routes' }

      it 'sends a GET request to the given path' do
        stub = stub_request(:get, 'https://api.mailgun.net/v3/routes')
          .with(basic_auth: ['api', 'key'])

        subject.get

        expect(stub).to have_been_requested
      end
    end

    context 'with query params' do
      let(:url) { 'https://api:key@api.mailgun.net/v3/routes' }

      it 'sends a GET request to the given path with the params' do
        stub = stub_request(:get, 'https://api.mailgun.net/v3/routes?limit=10')
          .with(basic_auth: ['api', 'key'])

        subject.get(limit: 10)

        expect(stub).to have_been_requested
      end
    end
  end

  describe '#post' do
    let(:url) { 'https://api:key@api.mailgun.net/v3/routes' }

    it 'sends a POST request with the params form-encoded' do
      stub = stub_request(:post, 'https://api.mailgun.net/v3/routes')
        .with(basic_auth: ['api', 'key'],
              body: 'action=forward&action=stop&description=yolo')

      subject.post(action: ['forward', 'stop'],
                   description: 'yolo')

      expect(stub).to have_been_requested
    end
  end

  describe '#put' do
    let(:url) { 'https://api:key@api.mailgun.net/v3/routes/123' }

    it 'sends a PUT request with the params form-encoded' do
      stub = stub_request(:put, 'https://api.mailgun.net/v3/routes/123')
        .with(basic_auth: ['api', 'key'],
              body: 'action=forward&action=stop&description=yolo')

      subject.put(action: ['forward', 'stop'],
                   description: 'yolo')

      expect(stub).to have_been_requested
    end
  end

  describe '#delete' do
    let(:url) { 'https://api:key@api.mailgun.net/v3/routes/123' }

    it 'sends a DELETE request with the params form-encoded' do
      stub = stub_request(:delete, 'https://api.mailgun.net/v3/routes/123')
        .with(basic_auth: ['api', 'key'])

      subject.delete

      expect(stub).to have_been_requested
    end
  end
end
