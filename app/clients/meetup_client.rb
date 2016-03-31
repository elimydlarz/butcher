class MeetupClient
  class << self
    def open_events(
      latitude: ENV.fetch('LOCATION_LATITUDE'),
      longitude: ENV.fetch('LOCATION_LONGITUDE'),
      radius: ENV.fetch('LOCATION_RADIUS_MILES')
    )
      response = RestClient.get(
        'https://api.meetup.com/2/open_events',
         params: {
           lat: latitude,
           lon: longitude,
           radius: radius,
           page: '20',
           category: '34',
           status: 'upcoming',
           key: ENV.fetch('MEETUP_API_KEY')
         }
      )

      JSON.parse(response, symbolize_names: true)[:results]
    end
  end
end