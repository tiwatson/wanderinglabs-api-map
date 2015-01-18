class Calculations::Categories

  attr_accessor :data, :map

  def initialize(map)
    @map = map
    @data = []

    summarize
    clean
  end

  def summarize
    all = map.map_places.sum(:stay_length)

    CATEGORY_NAMES.each_pair do |k,v|
      days = map.map_places.where(category: k).sum(:stay_length)
      cost = map.map_places.where(category: k).count > 0 ? map.map_places.where(category: k).sum(:price_total) : 0

      data.push({
        title: v,
        key: k,
        days: days,
        cost: cost,
        cost_per_day: cost > 0 && days > 0 ? cost / days : 0,
        percent: days > 0 ? ((days.to_f / all.to_f) * 100).round.to_i : 0
        })

      end
    end

    def clean
      data.select!{ |s| s[:days] > 0 }
    end

end
