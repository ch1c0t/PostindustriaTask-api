#\ -p 8080 -o 0.0.0.0
require_relative 'api'

class Root 
  include Hobby
  map('/api') { run API.new }
end

run Root.new
