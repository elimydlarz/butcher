class MeetupClient
  class << self
    def open_events(latitude:, longitude:, radius:)
      response = RestClient.get(
        'https://api.meetup.com/2/open_events',
         params: {
           lat: latitude,
           lon: longitude,
           radius: radius,
           page: '100',
           category: '34',
           status: 'upcoming',
           key: ENV.fetch('MEETUP_API_KEY')
         }
      )

      JSON.parse(response, symbolize_names: true)[:results]
    end
  end
end