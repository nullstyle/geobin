DB.create_table! :geographies, unlogged: true do
  String :type, size:255, null: false
  String :id,   size:255, null: false
  column :geog, "geography(Polygon,4326)", null: false

  index [:type, :id]
  index :geog, type: "gist"
end