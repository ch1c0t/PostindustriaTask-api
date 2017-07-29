require_relative 'db'

require 'hobby'
require 'hobby/json'

require_relative 'models/user'
require_relative 'models/company'

class Users
  include Hobby
  include JSON

  get do
    User.all
  end

  post do
    user = User.new json

    if user.valid?
      status 201
      user.save
    else
      status 422
      { 'errors' => user.errors }
    end
  end
end

class Companies
  include Hobby
  include JSON

  get do
    Company.all
  end

  post do
    if invalid_fields.empty?
      company = Company.new json

      if company.valid?
        status 201
        company.save
      else
        status 422
        { 'errors' => company.errors }
      end
    else
      response_for_invalid_fields
    end
  end

  put '/:id' do
    if invalid_fields.empty?
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
    else
      response_for_invalid_fields
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

  def invalid_fields
    @invalid_fields ||= begin
                          valid_fields = Company.columns[1..-1].map(&:to_s)
                          json.keys - valid_fields
                        end
  end

  def response_for_invalid_fields
    status 422
    {
      'errors' => {
        'invalid_fields' => invalid_fields
      }
    }
  end
end

class API
  include Hobby

  map('/users') { run Users.new }
  map('/companies') { run Companies.new }
end
