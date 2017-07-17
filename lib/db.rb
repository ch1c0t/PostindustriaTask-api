require 'timeout'
require 'sequel'
require 'mysql2'

DB_USER = ENV['DB_USER']
DB_PASS = ENV['DB_PASS']
DB_HOST = ENV['DB_HOST']
DB_NAME = ENV['DB_NAME']

# Throw a timeout error if the connection to the database
# will not be established in 20 seconds.
DB = Timeout.timeout 20 do
  begin
    Mysql2::Client.new host: DB_HOST, username: DB_USER, password: DB_PASS
    Sequel.connect "mysql2://#{DB_USER}:#{DB_PASS}@#{DB_HOST}/#{DB_NAME}"
  rescue Mysql2::Error
    puts $!
    puts 'Waiting for db...'
    sleep 1
    retry
  end
end

Sequel.extension :migration
Sequel::Migrator.run DB, 'migrations'
