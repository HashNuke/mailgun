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

    context 'when an error happens' do
      let(:url) { 'https://api:key@api.mailgun.net/v3/routes/123' }
      let(:error_body) { { "message" => "Expression is missing" }.to_json }

      before do
        stub_request(:get, 'https://api.mailgun.net/v3/routes/123')
          .with(basic_auth: ['api', 'key'])
          .to_return(status: [400, "Bad Request"],
                     body: error_body)
      end

      it 'raises exception that contains the error code and body' do
        begin
          subject.get
        rescue => e
          @exception = e
        end

        expect(@exception.http_code).to eq(400)
        expect(@exception.http_body).to eq(error_body)
      end
    end
  end

  describe '#post' do
    let(:url) { 'https://api:key@api.mailgun.net/v3/routes' }
    let(:params) { { action: ['forward', 'stop'], description: 'yolo' } }
    let(:response) do
      {
        "message" => "Route has been created",
        "route" => {
          "actions" => [
            "forward(\"stefan@metrilo.com\")",
            "stop()"
          ],
          "created_at" => "Wed, 15 Jun 2016 07:10:09 GMT",
          "description" => "Sample route",
          "expression" => "match_recipient(\".*@metrilo.com\")",
          "id" => "5760ff5163badc3a756f9d2c",
          "priority" => 5
        }
      }
    end

    before do
      stub_request(:post, 'https://api.mailgun.net/v3/routes')
        .with(basic_auth: ['api', 'key'],
              body: 'action=forward&action=stop&description=yolo')
        .to_return(body: response.to_json)
    end

    it 'sends a POST request with the params form-encoded' do
      expect(subject.post(params)).to eq(response.to_json)
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
