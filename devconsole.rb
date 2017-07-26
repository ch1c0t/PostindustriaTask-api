require 'sequel'
require 'mysql2'

DB_USER = ENV['DB_USER']
DB_PASS = ENV['DB_PASS']
DB_HOST = ENV['DB_HOST']
DB_NAME = ENV['DB_NAME']

DB = Sequel.connect adapter:  'mysql2',
                    username: DB_USER,
                    password: DB_PASS,
                    host:     DB_HOST,
                    database: DB_NAME

require_relative 'lib/models/company'

require 'pry'
binding.pry
:pry
