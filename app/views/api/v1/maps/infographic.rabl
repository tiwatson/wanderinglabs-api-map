object @map => nil

attributes :num_places, :num_nights, :num_free_nights, :percentage_free_nights, :per_night_fee, :walmart_count,
  :miles_towed, :average_towed

attributes :current_state_stay, :current_state_face, :consecutive_free

child @map.map_places do
  extends 'api/v1/map_places/infographic'
end

child @map.most_exspensive => :most_exspensive do
  extends 'api/v1/map_places/infographic'
end

child @map.map_places.last => :location_current do
  extends 'api/v1/map_places/infographic'
end

child @map.map_places.first => :location_first do
  extends 'api/v1/map_places/infographic'
end

child @map.longest_arrival_distance => :longest_arrival_distance do
  extends 'api/v1/map_places/infographic'
end

child @map.shortest_arrival_distance => :shortest_arrival_distance do
  extends 'api/v1/map_places/infographic'
end

node(:num_states) { @states.size }

node(:categories) { @categories }
node(:states) { @states }
node(:monthlies) { @monthlies }
attributes :path
