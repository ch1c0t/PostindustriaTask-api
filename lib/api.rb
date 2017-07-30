require_relative 'db'

require 'hobby'
require 'hobby/json'

require_relative 'models/user'
require_relative 'models/company'
require_relative 'resource'

class API
  include Hobby

  map('/users') { run Resource.new User }
  map('/companies') { run Resource.new Company }
end
