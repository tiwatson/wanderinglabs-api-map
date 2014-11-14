class Map < ActiveRecord::Base
  has_many :map_places


  def d3_tracks(year)
    map_places.select { |mp| mp.ww_year == year }.collect { |mp| mp.arrival_path_small }.flatten(1)
  end

end
