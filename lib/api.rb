require_relative 'db'

require 'hobby'
require 'hobby/json'

class Company < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :quota]

    if errors.empty?
      validates_type [Float, Integer], :quota
      validates_max_length 255, :name
    end
  end
end

class Companies
  include Hobby
  include JSON

  get do
    DB[:companies].all
  end

  post do
    company = Company.new json

    if company.valid?
      response.status = 201
      company.save
      company.values
    else
      response.status = 422
      { 'errors' => company.errors }
    end
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
