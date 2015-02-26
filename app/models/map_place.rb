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
    i.price_total = i.price_adjusted * i.stay_length
  end

  before_save do |i|
    i.calculate_arrival_distance if i.arrival_path.present?
  end

  before_save do |i|
    i.calculate_elevation if i.latitude_changed?
  end

  def price_adjusted
    return self.price unless self.state == 'New Mexico' && self.category == 'SP'

    nm_per_day = 4 # (225.to_f / self.map.map_places.where(state: 'New Mexico').where(category: 'SP').sum(:stay_length)).round

    nm_price = self.price - 10
    nm_price = 0 if nm_price < 0
    nm_price = nm_price + nm_per_day
    nm_price
  end

  def state_short
    self.state.present? && STATE_ABBR.has_value?(self.state) ? STATE_ABBR.key(self.state) : self.state
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

  def calculate_elevation
    elv_url = "http://ned.usgs.gov/epqs/pqs.php?x=#{self.longitude}&y=#{self.latitude}&units=Feet&output=json"
    require 'open-uri'
    content = open(elv_url).read
    json = JSON.parse(content)
    puts elv_url
    puts self.title
    puts json.inspect
    if !json['USGS_Elevation_Point_Query_Service']['Elevation_Query']['Elevation'].is_a?(String)
      self.elevation = json['USGS_Elevation_Point_Query_Service']['Elevation_Query']['Elevation'].round.to_i
    end
  end

end
