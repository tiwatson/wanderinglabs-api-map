
node(:type) { 'Feature' }
node(:properties) do |object|
  partial("api/v1/map_places/_d3_map_properties", :object => object)
end
node(:geometry) do |object|
  {
    type: 'Point',
    coordinates: [object.longitude, object.latitude]
  }
end
