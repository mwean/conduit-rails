# Configure Rails Envinronment
#
ENV["RAILS_ENV"] = "test"

# Require Files
#
require File.expand_path("../dummy/config/environment", __FILE__)
require "database_cleaner"
require "shoulda/matchers"
require "rspec/rails"
require "excon"
require "conduit"

# Load all of the _spec.rb files
#
Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].each { |f| require f }

# Rspec Configuration
#
RSpec.configure do |config|
  config.include Helper

  config.expect_with(:rspec) { |c| c.syntax = :should }

  config.before(:suite) do
    Excon.defaults[:mock] = true
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.strategy = :transaction
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
