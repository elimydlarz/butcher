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
        time: tomorrow.to_i * 1000
      }
    end

    let(:incomplete_meetup) do
      {
        name: 'Minimum Meetup',
        group: { name: 'Goodbye Moon-men' },
        time: tomorrow.to_i * 1000
      }
    end

    let(:meetup_over_8_days_from_now) do
      {
        name: 'Meetup Over 8 Days From Now',
        group: { name: 'Get Schwifty' },
        time: over_8_days_from_now.to_i * 1000
      }
    end

    let(:today) { Time.at(1458111600) }
    let(:tomorrow) { today + 86400 }
    let(:over_8_days_from_now) { today + 691201 }
    let(:api_key_stub) { 'TEST_API_KEY' }

    before do
      allow(ENV).to receive(:fetch).with('MEETUP_API_KEY') { api_key_stub }
      allow(Time).to receive(:now) { today }

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
        body: { results: [meetup, incomplete_meetup, meetup_over_8_days_from_now] }.to_json
      )
    end

    it 'displays meetup details' do
      expect(subject.body).to include meetup[:name]
      expect(subject.body).to include meetup[:group][:name]
      expect(subject.body).to include meetup[:venue][:name]
      expect(subject.body).to include meetup[:venue][:address_1]
      expect(subject.body).to include meetup[:venue][:address_2]
      expect(subject.body).to include Time.at(meetup[:time] / 1000).strftime('%A, %e %B at %k:%M')
    end

    it 'omits meetups more than 8 days from now' do
      expect(subject.body).not_to include meetup_over_8_days_from_now[:name]
    end
  end
end
