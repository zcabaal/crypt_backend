require 'rubygems'
require 'bundler'

Bundler.require(:default,:development)
# noinspection RubyArgCount
Dotenv.load
Mongoid.load!('mongoid.yml', :development)

require './web'
require './api'
run Rack::Cascade.new [Web, API]