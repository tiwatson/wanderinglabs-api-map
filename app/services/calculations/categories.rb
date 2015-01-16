class Calculations::Categories

  attr_accessor :data, :map

  def initialize(map)
    @map = map
    @data = {}

    summarize
    clean
  end

  def summarize
    CATEGORY_NAMES.each_pair do |k,v|
      data[k] = {
        days: map.map_places.where(category: k).sum(:stay_length),
        cost: map.map_places.where(category: k).count > 0 ? map.map_places.where(category: k).sum(:price_total) : 0
      }

      data[k][:cost_per_day] = data[k][:cost] > 0 && data[k][:days] > 0 ?
      data[k][:cost] / data[k][:days] : 0

    end
  end

  def clean
    data.delete_if{ |k,v| v[:days] == 0 }
  end


end
