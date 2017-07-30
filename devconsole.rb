require 'sequel'
require 'mysql2'

DB = Sequel.connect DB_URL

require_relative 'lib/models/company'
require_relative 'lib/models/user'

require 'pry'
binding.pry
:pry
