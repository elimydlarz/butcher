require 'sinatra'
require 'rest-client'
require './app/clients/meetup_client'

get '/' do
  haml :index, locals: { meetups: MeetupClient.open_events }
end
