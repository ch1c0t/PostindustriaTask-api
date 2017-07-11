require 'mysql2'
require 'hobby'
require 'hobby/json'


# Throw a timeout error if the connection to the database
# will not be established in 20 seconds.
require 'timeout'
DB = Timeout.timeout 20 do
  begin
    Mysql2::Client.new host: 'db', username: 'root', password: 'root'
  rescue Mysql2::Error
    puts 'Waiting for db...'
    sleep 1
    retry
  end
end


class API
  include Hobby
  include JSON

  get do
    DB.query('show databases').to_a
  end

  get '/some_route' do
    'some'
  end
end
