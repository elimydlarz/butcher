require 'spec_helper'

describe 'butcher' do
  describe 'landing page' do
    it 'returns Hello World' do
      get '/'
      expect(last_response.body).to eq 'Hello World'
    end
  end
end

