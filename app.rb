require 'rubygems'
require 'bundler'

Bundler.require

require 'csv'
require 'sinatra/reloader' if development?

get '/' do
  @attendees = CSV.read("rcx.csv")[1..-2].map{|a| a[2][1..-1] if a[2] }
  
  haml :index
end