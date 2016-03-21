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
        body: response_from_meetup_dot_com
      )
    end

    context 'when meetup.com returns a list of meetups' do
      open_events_melbourne_fixture = JSON.parse(
        File.read('./spec/fixtures/open_events_melbourne.json'),
        symbolize_names: true
      )
      meetups = open_events_melbourne_fixture[:results]

      let(:response_from_meetup_dot_com) { open_events_melbourne_fixture.to_json }

      meetups.each do |meetup|
        it 'displays the meetup name' do
          expect(subject.body).to include meetup[:name]
        end

        it 'displays the meetup group name' do
          expect(subject.body).to include meetup[:group][:name]
        end

        it 'displays the meetup venue' do
          if meetup.has_key? :venue
            expect(subject.body).to include meetup[:venue][:name]
          end
        end
      end
    end
  end
end
