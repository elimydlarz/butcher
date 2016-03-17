require 'sinatra'
require 'rest-client'

get '/' do
  RestClient.get('https://api.meetup.com/2/open_events',
     params: {
        lon: '144.9631',
        page: '20',
        radius: '10.0',
        category: '34',
        lat: '-37.8136',
        status: 'upcoming',
        key: ENV.fetch('MEETUP_API_KEY')
     }
  )
end
