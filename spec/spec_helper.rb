require "bundler/setup"
require "activerecord/explain/analyze"
require 'rspec'
require 'rspec/collection_matchers'
require 'rspec/its'

RSpec.configure do |config|
  config.filter_run :focus
  config.expose_dsl_globally = true
  config.run_all_when_everything_filtered = true

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
