#import into tz_world table

Dir.chdir("../data") do
  system("unzip tz_world.zip")
  Dir.chdir("world"){ system "shp2pgsql -G -s 4326 -I -S -D tz_world.shp > tz_world.sql" }

  system "psql --host 127.0.0.1 --username geobin < /geobin/data/world/tz_world.sql"
end

# move into geographies table
DB[:geographies].import([:type, :id, :geog], DB[:tz_world].select("timezone", :tzid, :geog))

# remove tz_world, since we will use it through geographies instead

DB.drop_table :tz_world