require 'sequel'
require 'pg'

DB = Sequel.connect('postgres://geobin:geobin@localhost/geobin') 
DB.extension :pg_hstore

Dir["steps/*.rb"].sort.each do |path|
  puts "running #{File.basename(path)}"
  load path
end
