require 'spec_helper'

describe 'butcher' do
  describe 'landing page' do
    subject { get '/' }

    let(:meetup) do
      {
        name: 'Complete Meetup',
        group: { name: 'Melbourne Business Intelligence Meetup' },
        venue: {
          name: 'Queens Collective',
          address_1: 'Level 1, 20 Queens St',
          address_2: 'Melbourne, Victoria'
        },
        time: 1458198000000
      }
    end

    let(:incomplete_meetup) do
      {
        name: 'Minimum Meetup',
        group: { name: 'Goodbye Moon-men' },
      }
    end

    before do
      api_key_stub = 'TEST_API_KEY'
      allow(ENV).to receive(:fetch).with('MEETUP_API_KEY') { api_key_stub }

      stub_request(
        :get, 'https://api.meetup.com/2/open_events'
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
        body: { results: [meetup, incomplete_meetup] }.to_json
      )
    end

    it 'displays meetup details' do
      expect(subject.body).to include meetup[:name]
      expect(subject.body).to include meetup[:group][:name]
      expect(subject.body).to include meetup[:venue][:name]
      expect(subject.body).to include meetup[:venue][:address_1]
      expect(subject.body).to include meetup[:venue][:address_2]
      expect(subject.body).to include Time.at(meetup[:time] / 1000).strftime('%A, %e %B')
    end
  end
end
