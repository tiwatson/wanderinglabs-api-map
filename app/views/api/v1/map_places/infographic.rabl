object @map_place => nil
attributes :title, :city, :state_short, :stay_length, :price, :latitude, :longitude, :arrived, :category, :elevation

node(:arrival_distance) do |mp|
  mp.arrival_distance.round(1)
end
