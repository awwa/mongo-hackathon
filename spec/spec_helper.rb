require File.join(File.dirname(__FILE__), '../src', 'main.rb')
require File.join(File.dirname(__FILE__), '../src', 'db_access.rb')
require File.join(File.dirname(__FILE__), '../src', 'item_data.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
