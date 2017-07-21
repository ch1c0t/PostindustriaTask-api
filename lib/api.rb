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
    key :name, String, size: [:<=, 255]
    key :quota, [Float, Integer]

    if errors.empty?
      DB[:companies].insert keys

      response.status = 201
      DB[:companies].where(name: keys[:name]).first
    else
      response.status = 422
      { 'errors' => errors }
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
