class Calculations::States

  attr_accessor :data, :map

  def initialize(map)
    @map = map
    @data = []

    summarize
    clean
  end

  def summarize
    STATE_ABBR.each_pair do |k,v|
      days = map.map_places.where(state: v).sum(:stay_length)
      cost = map.map_places.where(state: v).count > 0 ? map.map_places.where(state: v).sum(:price_total) : 0

      data.push({
        state: k,
        days: days,
        cost: cost,
        cost_per_day: cost > 0 && days > 0 ? cost / days : 0
      })

    end
  end

  def clean
    data.select!{ |s| s[:days] > 0 }
  end


end
