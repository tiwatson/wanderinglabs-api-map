class Map < ActiveRecord::Base
  has_many :map_places


  def d3_tracks(year)
    Rails.cache.fetch("d3_tracks::#{year}", expires_in: 1.day) do
      puts "d3_tracks::#{year} not cached"
      DouglasPeucker::LineSimplifier.new(self.map_places.select { |mp| mp.ww_year == year }.map(&:arrival_path).flatten(1).collect { |i| [i[0].to_f, i[1].to_f]}).threshold(0.05).points
    end
  end

  def info_tracks(force = false)
    Rails.cache.fetch("info_tracks", expires_in: 1.day, force: force) do
      puts "info_tracks not cached"
      DouglasPeucker::LineSimplifier.new(self.map_places.pluck(:arrival_path).flatten(1).collect { |i| [i[0].to_f, i[1].to_f]}).threshold(0.05).points
    end
  end
end
