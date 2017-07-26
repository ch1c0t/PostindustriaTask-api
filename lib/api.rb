require_relative 'db'

require 'hobby'
require 'hobby/json'

require_relative 'models/company'

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
