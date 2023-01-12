require "bundler/setup"
require "activerecord-explain-analyze"
require 'rspec'
require 'rspec/collection_matchers'
require 'rspec/its'
require 'database_cleaner'
require 'pg'

class Car < ActiveRecord::Base
end

def db_config
  @db_config ||= begin
    filepath = File.join('spec', 'database.yml')
    YAML.load_file(filepath)['postgres']
  end
end

def establish_connection(config)
  ActiveRecord::Base.establish_connection(config)
  ActiveRecord::Base.connection
end

def create_database
  pg_connection = PG.connect({
    dbname: 'postgres',
    host: db_config['host'],
    port: db_config['port'],
    username: db_config['username'],
    password: db_config['password'],
  })
  pg_connection.exec(%{DROP DATABASE IF EXISTS "#{db_config['database']}";})
  pg_connection.exec(%{CREATE DATABASE "#{db_config['database']}";})
  ar_connection = establish_connection(db_config)
  ar_connection.create_database(db_config['database']) rescue nil
end

def create_table
  connection = establish_connection(db_config)
  connection.create_table(:cars, :force => true) do |t|
    t.column :model, :string
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.expose_dsl_globally = true
  config.run_all_when_everything_filtered = true

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    create_database
    create_table

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
