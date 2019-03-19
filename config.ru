Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

require_relative 'magicians_red'


App = MagiciansRed.new
require File.join(File.dirname(__FILE__),'config', 'routes') 

run MagiciansRed::Controller.new(App)
