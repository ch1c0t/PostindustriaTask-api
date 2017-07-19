require_relative 'db'

require 'hobby'
require 'hobby/json'

class Companies
  include Hobby
  include JSON

  get do
    DB[:companies].all
  end

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

  def validate json
    errors = Hash.new { |h,k| h[k] = [] }

    quota = json['quota']
    unless quota
      errors['quota'] << 'is missing'
    end

    unless quota&.is_a?(Float) || quota&.is_a?(Integer)
      if quota
        errors['quota'] << "expected Float or Integer, got #{quota.class}"
      end
    end

    name = json['name']
    unless name
      errors['name'] << 'is missing'
    end

    unless name&.is_a? String
      if name
        errors['name'] << "expected String, got #{json['name'].class}"
      end
    end

    if name && name.size > 255
      errors['name'] << "cannot exceed 255 characters"
    end

    errors
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
