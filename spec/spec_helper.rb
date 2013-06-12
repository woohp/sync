ENV["RAILS_ENV"] ||= "test"

puts File.expand_path("../../spec/dummy/config/environment", __FILE__)
require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'websocket_rails/spec_helpers'
