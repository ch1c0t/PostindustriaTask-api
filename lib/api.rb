require_relative 'db'

require 'hobby'
require 'hobby/json'

class Companies
  include Hobby
  include JSON

  post do
    errors = validate json

    if errors.empty?
      name, quota = json.values_at 'name', 'quota'
      hash = { name: name, quota: quota }
      DB[:companies].insert hash

      response.status = 201
      DB[:companies].where(name: name).first
    else
      response.status = 422
      { 'errors' => errors }
    end
  end

  get do
    DB[:companies].all
  end

  def validate json
    errors = {}

    if json['name'].size > 255
      errors['name'] = [ "cannot exceed 255 characters" ]
    end

    errors
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
