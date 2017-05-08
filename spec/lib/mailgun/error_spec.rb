require 'spec_helper'

describe Mailgun::Error do
  describe '.from_client_error' do
    let(:client_error) { Mailgun::ClientError.new(http_code: code, http_body: body) }
    let(:returned_exception) { described_class.from_client_error(client_error) }

    context '400' do
      let(:code) { 400 }
      let(:body) { "{\n  \"message\": \"'to' parameter is not a valid address. please check documentation\"\n}" }

      it 'returns Mailgun::BadRequest exception' do
        expect(returned_exception).to be_kind_of Mailgun::BadRequest
      end

      it 'returns parses the message' do
        expect(returned_exception.message).to eq "'to' parameter is not a valid address. please check documentation"
      end
    end

    context '401' do
      let(:code) { 401 }
      let(:body) { "{\n  \"message\": \"unauthorized\"\n}" }

      it 'returns Mailgun::Unauthorized exception' do
        expect(returned_exception).to be_kind_of Mailgun::Unauthorized
      end

      it 'returns parses the message' do
        expect(returned_exception.message).to eq "unauthorized"
      end
    end

    context '402' do
      let(:code) { 402 }
      let(:body) { "{\n  \"message\": \"insufficient balance\"\n}" }

      it 'returns Mailgun::ResquestFailed exception' do
        expect(returned_exception).to be_kind_of Mailgun::ResquestFailed
      end

      it 'returns parses the message' do
        expect(returned_exception.message).to eq "insufficient balance"
      end
    end

    context '404' do
      let(:code) { 404 }
      let(:body) { "{\n  \"message\": \"Domain not found: superstore.com\"\n}" }

      it 'returns Mailgun::NotFound exception' do
        expect(returned_exception).to be_kind_of Mailgun::NotFound
      end

      it 'returns parses the message' do
        expect(returned_exception.message).to eq 'Domain not found: superstore.com'
      end
    end

    context '502' do
      let(:code) { 502 }
      let(:body) { "{\n  \"message\": \"bad gateway\"\n}" }

      it 'returns Mailgun::ServerError exception' do
        expect(returned_exception).to be_kind_of Mailgun::ServerError
      end

      it 'returns parses the message' do
        expect(returned_exception.message).to eq 'bad gateway'
      end
    end
  end
end
