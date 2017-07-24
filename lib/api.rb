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
      validates_unique :name
      errors.add :quota, 'cannot be 0' if quota == 0
    end
  end

  def to_json
    values.to_json
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
      status 201
      company.save
    else
      status 422
      { 'errors' => company.errors }
    end
  end

  put '/:id' do
    if company = Company[my[:id]]
      company.update json

      if company.valid?
        company.save
      else
        status 422
        { 'errors' => company.errors }
      end
    else
      status 404
      { 
        'errors' => {
          'id' => ['not found']
        }
      }
    end
  end

  delete '/:id' do
    id = my[:id]

    if company = Company[id]
      company.delete
      status 204
    else
      status 404
      { 'errors' => "company with id #{id} was not found" }
    end
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
