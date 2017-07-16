require_relative 'db'

require 'hobby'
require 'hobby/json'

class Companies
  include Hobby
  include JSON

  post do
    name, quota = json.values_at 'name', 'quota'
    hash = { name: name, quota: quota }
    DB[:companies].insert hash

    response.status = 201
    DB[:companies].where(name: name).first
  end

  get do
    DB[:companies].all
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
