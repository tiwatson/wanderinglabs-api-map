class Calculations::Monthlies

  attr_accessor :data, :map

  def initialize(map)
    @map = map
    @data = []

    summarize
  end

  def summarize
    months = {}
    map.map_places.each do |mi|
      mi.stay_length.times do |x|
        mi_date = mi.arrived + x.days
        mi_date_text = "1-#{mi_date.month}-#{mi_date.year}"
        puts mi_date_text
        months[mi_date_text] ||= 0
        months[mi_date_text] += mi.price
      end
    end

    months.collect do |k,v|
      data.push({
        date: k,
        cost: v
      })
    end

  end

end
