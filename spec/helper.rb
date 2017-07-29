ENV['DB_USER'] = 'dev'
ENV['DB_PASS'] = 'devpass'
ENV['DB_NAME'] = 'devdb'
ENV['DB_HOST'] = '127.0.0.1'

require_relative '../lib/api'
require 'hobby/devtools/rspec_helper'

def clear_db
  DB.run 'SET FOREIGN_KEY_CHECKS = 0'
  DB[:companies].truncate
  DB[:users].truncate
  DB.run 'SET FOREIGN_KEY_CHECKS = 1'
end

RSpec.configure do |config|
  config.before :each do
    clear_db
  end

  config.after :suite do
    clear_db
  end
end
