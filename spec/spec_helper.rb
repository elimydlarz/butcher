require 'rspec'
require 'rack/test'
require 'byebug'

ENV['RACK_ENV'] = 'test'

require './butcher'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }

