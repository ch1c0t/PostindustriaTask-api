DB_URL = 'mysql2://dev:devpass@127.0.0.1/devdb'

namespace :db do
  task :migrate, [:version] do |t, args|
    require 'sequel'
    require 'mysql2'

    Sequel.extension :migration
    db = Sequel.connect DB_URL

    if args[:version]
      Sequel::Migrator.run db, 'migrations', target: args[:version].to_i
    else
      Sequel::Migrator.run db, 'migrations'
    end
  end
end

task :console do
  load 'devconsole.rb'
end
