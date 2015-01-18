class MapPlace < ActiveRecord::Base

  belongs_to :map
  has_many :map_place_links

  default_scope { order('arrived, id ASC') }

  reverse_geocoded_by :latitude, :longitude do |obj,results|
    logger.debug "REVERSE GEO: #{results.inspect}"
    if geo = results.first
      obj.city    = geo.city
      obj.state   = geo.state

      est = geo.data['address_components'].select{ |i| i['types'].include?('establishment') }
      if est.present?
        obj.establishment = est.first['short_name']
      end
    end
  end

  before_save do |i|
    i.reverse_geocode if i.city.nil?
  end

  before_save do |i|
    i.calculate_stay_length
    i.price_total = i.price * i.stay_length
  end

  before_save do |i|
    i.calculate_arrival_distance
  end

  def state_short
    self.state.present? ? STATE_ABBR.key(self.state) : ''
  end

  def category_name
    CATEGORY_NAMES[self.category.to_sym]
  end

  def link_summary
    self.map_place_links.collect do |mpl|
      "<a href='#{mpl.url}' target='_BLANK'>#{mpl.title}</a>"
    end.join(' - ')
  end

  def ww_year
    if self.arrived < Date.parse('14-06-2013')
      0
    elsif self.arrived < Date.parse('14-06-2014')
      1
    else
      2
    end
  end

  def arrival_path_small
    self.arrival_path
  end

  def state_short
    self.state.present? ? STATE_ABBR.key(self.state) : ''
  end

  def calculate_stay_length
    next_mi = self.map.map_places.where('arrived > ?', self.arrived).first
    next_mi_arrived = next_mi.present? ? next_mi.arrived : Date.today
    self.stay_length = (next_mi_arrived - self.arrived).to_i
  end

  def calculate_stay_length!
    self.calculate_stay_length
    self.save
  end

  def calculate_arrival_distance
    self.arrival_distance = GeoRuby::SimpleFeatures::LineString.from_coordinates(self.arrival_path.collect { |i| [i[0].to_f, i[1].to_f]}).spherical_distance() / 1609.344
  end

end
