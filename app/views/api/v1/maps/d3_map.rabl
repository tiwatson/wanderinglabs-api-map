object @map => nil

child @map.map_places.unscoped.order('arrived DESC'), :root => :points, :object_root => false do
  extends "api/v1/map_places/d3_map_points"
end

node(:tracks) do
  [
    {
      track: [
        {
          type: 'Feature',
          id: '01',
          properties: {
            name: 'Linestring'
          },
          geometry: {
            type: 'LineString',
            coordinates: @map.d3_tracks(0)
          }
        }
      ]
    },
  {
    track: [
      {
        type: 'Feature',
        id: '01',
        properties: {
          name: 'Linestring'
        },
        geometry: {
          type: 'LineString',
          coordinates: @map.d3_tracks(1)
        }
      }
    ]
  },
  {
    track: [
      {
        type: 'Feature',
        id: '01',
        properties: {
          name: 'Linestring'
        },
        geometry: {
          type: 'LineString',
          coordinates: @map.d3_tracks(2)
        }
      }
    ]
  },
  {
    track: [
      {
        type: 'Feature',
        id: '01',
        properties: {
          name: 'Linestring'
        },
        geometry: {
          type: 'LineString',
          coordinates: @map.d3_tracks(3)
        }
      }
    ]
  }

  ]

end
