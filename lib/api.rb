require_relative 'db'

require 'hobby'
require 'hobby/json'

class Company < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :quota]

    if errors.empty?
      p name
      validates_type String, :name # doesn't work as I expected
      p name
      p "name is #{name}"
      unless name.is_a? String
        errors.add :name, "expected String, got #{name.class}"
      end

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
      p company.errors
      { 'errors' => company.errors }
    end
  end
  
  def keys
    @keys ||= {}
  end

  def errors
    @errors ||= Hash.new { |h,k| h[k] = [] }
  end

  def check_that_type_of value, with:, is:
    name, type = with, is
    case type
    when Module
      unless value.is_a? type
        errors[name] << "expected #{type}, got #{value.class}"
      end
    when Array
      types = type
      unless types.any? { |type| value.is_a? type }
        errors[name] << "expected #{types.join ' or '}, got #{value.class}"
      end
    end
  end

  def key name, type, **constraints
    if value = json[name.to_s]
      check_that_type_of value, with: name, is: type

      if constraint = constraints[:size]
        comparator, number = constraint
        unless value.size.send(comparator, number)
          errors[name] << "cannot exceed 255 characters"
        end
      end
    else
      errors[name] << 'is missing'
    end

    if errors.empty?
      keys[name] = value
    end
  end
end

class API
  include Hobby

  map('/companies') { run Companies.new }
end
