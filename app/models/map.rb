class Map < ActiveRecord::Base
  has_many :map_places


  def d3_tracks(year)
    DouglasPeucker::LineSimplifier.new(self.map_places.select { |mp| mp.ww_year == year }.map(&:arrival_path).flatten(1).collect { |i| [i[0].to_f, i[1].to_f]}).threshold(0.05).points
  end

end
