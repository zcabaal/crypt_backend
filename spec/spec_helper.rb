ENV['RACK_ENV'] = 'test'
require 'simplecov'
require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
SimpleCov.coverage_dir(ENV['COVERAGE_REPORTS'])
SimpleCov.start

require 'bundler/setup'

Bundler.require(:default, :test)
# noinspection RubyArgCount
Dotenv.load
Mongoid.load!('mongoid.yml', :test)

require './models'
require './web'
require './api/root'

RSpec.configure do |c|
  c.mock_with :rspec
  c.include Rack::Test::Methods

end

