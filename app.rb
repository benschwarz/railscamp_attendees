require 'rubygems'
require 'bundler'

Bundler.require

require 'csv'
require 'sinatra/reloader' if development?

get '/' do
  @attendees = AttendeeList.new("rcx.csv").with_twitter
  
  haml :index
end

# Sinatra::Reloader can't reload Struct subclasses :(
if defined?(AttendeeList)
  [ :AttendeeList, :Attendee ].each { |c| Object.send(:remove_const, c) }
end

class AttendeeList < Struct.new(:path)
  def all; CSV.read(path)[1..-1].map { |row| Attendee.new(*row) } end
  def with_twitter; all.select(&:twitter?) end
end

class Attendee < Struct.new(:first_name, :last_name, :twitter)
  def full_name;   [ first_name, last_name ].compact.join(" ") end
  def twitter?;    !twitter.nil? && twitter.length > 0 end
  def username;    twitter[1..-1] end
  def url;         "https://twitter.com/#{username}" end
  def image_url;   "http://img.tweetimag.es/i/#{username}_b" end
  def description; "#{full_name} (#{twitter})" end
end
