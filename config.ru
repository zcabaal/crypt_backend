require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)
# noinspection RubyArgCount
Dotenv.load
Mongoid.load!('mongoid.yml', :development)

require './models'
require './web'
require './api/root'
run Rack::Cascade.new [Web, API::Root]