require_relative 'db'

require 'hobby'
require 'hobby/json'

require_relative 'models/user'
require_relative 'models/company'

class Resource
  include Hobby
  include JSON

  def initialize model
    @model = model
  end

  get do
    @model.all
  end

  post do
    if invalid_fields.empty?
      model = @model.new json

      if model.valid?
        status 201
        model.save
      else
        status 422
        { 'errors' => model.errors }
      end
    else
      response_for_invalid_fields
    end
  end

  put '/:id' do
    if invalid_fields.empty?
      if model = @model[my[:id]]
        model.update json

        if model.valid?
          model.save
        else
          status 422
          { 'errors' => model.errors }
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

    if model = @model[id]
      model.delete
      status 204
    else
      status 404
      { 'errors' => "#{@model.name} with id #{id} was not found" }
    end
  end

  def invalid_fields
    @invalid_fields ||= begin
                          valid_fields = @model.columns[1..-1].map(&:to_s)
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

  map('/users') { run Resource.new User }
  map('/companies') { run Resource.new Company }
end
