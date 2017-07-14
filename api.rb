require_relative 'db'

require 'hobby'
require 'hobby/json'

class API
  include Hobby
  include JSON

  get do
    DB.tables
  end

  get '/some_route' do
    'some'
  end
end
