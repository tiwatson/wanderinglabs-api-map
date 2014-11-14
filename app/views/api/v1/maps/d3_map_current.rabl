
node do
  partial("api/v1/map_places/d3_map_points", :object => @map.map_places.last)
end
