require 'spec_helper'

describe 'butcher' do
  describe 'landing page' do
    let(:meetup) do
      {
        name: 'Complete Meetup',
        group: { name: 'Melbourne Business Intelligence Meetup' },
        venue: {
          name: 'Queens Collective',
          address_1: 'Level 1, 20 Queens St',
          address_2: 'Melbourne, Victoria'
        },
        time: tomorrow.to_i * 1000,
        utc_offset: 39600000
      }
    end

    let(:incomplete_meetup) do
      {
        name: 'Minimum Meetup',
        group: { name: 'Goodbye Moon-men' },
        time: tomorrow.to_i * 1000,
        utc_offset: 39600000
      }
    end

    let(:meetup_over_8_days_from_now) do
      {
        name: 'Meetup Over 8 Days From Now',
        group: { name: 'Get Schwifty' },
        time: over_8_days_from_now.to_i * 1000,
        utc_offset: 39600000
      }
    end

    let(:today) { Time.at(1458111600) }
    let(:tomorrow) { today + 86400 }
    let(:over_8_days_from_now) { today + 691201 }
    let(:api_key) { 'test api key' }
    let(:number_of_meetups) { '100' }

    before do
      allow(ENV).to receive(:fetch).with('MEETUP_API_KEY') { api_key }
      allow(Time).to receive(:now) { today }
    end

    shared_examples 'meetup list' do
      it 'displays meetup details' do
        meetup_local_time = Time.at((meetup[:time] + meetup[:utc_offset]) / 1000)

        expect(subject.body).to include meetup[:name]
        expect(subject.body).to include meetup[:group][:name]
        expect(subject.body).to include meetup[:venue][:name]
        expect(subject.body).to include meetup[:venue][:address_1]
        expect(subject.body).to include meetup[:venue][:address_2]
        expect(subject.body).to include meetup_local_time.strftime('%A, %e %B at %k:%M')
      end

      it 'omits meetups more than 8 days from now' do
        expect(subject.body).not_to include meetup_over_8_days_from_now[:name]
      end
    end

    context 'when default location is used' do
      subject { get '/' }

      before do
        latitude = '-33.865143'
        longitude = '151.209900'
        radius = '20.0'

        allow(ENV).to receive(:fetch).with('LOCATION_LATITUDE') { latitude }
        allow(ENV).to receive(:fetch).with('LOCATION_LONGITUDE') { longitude }
        allow(ENV).to receive(:fetch).with('LOCATION_RADIUS_MILES') { radius }

        stub_request(
          :get, 'https://api.meetup.com/2/open_events'
        ).with(
           query: {
             status: 'upcoming',
             category: '34',
             lat: latitude,
             lon: longitude,
             radius: radius,
             page: number_of_meetups,
             key: api_key
           }
        ).to_return(
          body: { results: [meetup, incomplete_meetup, meetup_over_8_days_from_now] }.to_json
        )
      end

      it_behaves_like 'meetup list'
    end

    context 'when location is overridden in URL params' do
      let(:latitude) { '-37.8136' }
      let(:longitude) { '144.9631' }
      let(:radius) { '20.0' }

      subject { get '/', latitude: latitude, longitude: longitude, radius: radius }

      before do
        stub_request(
          :get, 'https://api.meetup.com/2/open_events'
        ).with(
          query: {
            status: 'upcoming',
            category: '34',
            lat: latitude,
            lon: longitude,
            radius: radius,
            page: number_of_meetups,
            key: api_key
          }
        ).to_return(
          body: { results: [meetup, incomplete_meetup, meetup_over_8_days_from_now] }.to_json
        )
      end

      it_behaves_like 'meetup list'
    end
  end
end
