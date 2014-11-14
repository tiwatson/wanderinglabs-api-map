collection @map_places

node(:type) { 'Feature' }
node(:properties) do |object|
  {
    name: object.title,
    description: object.description,
    city: object.city,
    state: object.state,
    price: object.price
  }
end
node(:geometry) do |object|
  {
    type: 'Point',
    coordinates: [object.longitude, object.latitude]
  }
end
