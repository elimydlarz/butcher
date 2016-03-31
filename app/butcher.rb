require 'sinatra'
require 'rest-client'
require './app/clients/meetup_client'

get '/' do
  meetups = MeetupClient.open_events(
    latitude: params[:latitude]   || ENV.fetch('LOCATION_LATITUDE'),
    longitude: params[:longitude] || ENV.fetch('LOCATION_LONGITUDE'),
    radius: params[:radius]       || ENV.fetch('LOCATION_RADIUS_MILES')
  )
  near_future_meetups = meetups.select { |meetup| time_of(meetup) < days_from_now(8) }

  haml :index, locals: { meetups: near_future_meetups }
end

private

def time_of(meetup)
  Time.at(meetup[:time] / 1000)
end

def days_from_now(number_of_days)
  Time.now + number_of_days * 86400
end
