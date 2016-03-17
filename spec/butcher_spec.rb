require 'spec_helper'

describe 'butcher' do
  describe 'landing page' do
    subject { get '/' }

    before do
      api_key_stub = 'TEST_API_KEY'
      allow(ENV).to receive(:fetch).with('MEETUP_API_KEY') { api_key_stub }

      stub_request(
        :get,
        'https://api.meetup.com/2/open_events'
      ).with(
         query: {
           status: 'upcoming',
           category: '34',
           lat: '-37.8136',
           lon: '144.9631',
           radius: '10.0',
           page: '20',
           key: api_key_stub
         }
      ).to_return(
        body: response_from_meetup.to_json
      )
    end

    context 'when meetup.com gives us a list of meetups' do
      let(:response_from_meetup) { JSON.parse(response_fixture, symbolize_names: true) }
      let(:response_fixture) { File.read('./spec/fixtures/open_events_melbourne.json') }

      it 'displays the list of meetups' do
        expect(subject.body).to eq response_from_meetup.to_json
      end
    end
  end
end

