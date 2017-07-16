ENV['DB_USER'] = 'dev'
ENV['DB_PASS'] = 'devpass'
ENV['DB_NAME'] = 'devdb'
ENV['DB_HOST'] = '127.0.0.1'

require_relative '../api'
require 'hobby/devtools/rspec_helper'

RSpec.configure do |config|
  config.before :each do
    DB.run 'SET FOREIGN_KEY_CHECKS = 0'
    DB[:companies].truncate
    DB.run 'SET FOREIGN_KEY_CHECKS = 1'
  end
end
