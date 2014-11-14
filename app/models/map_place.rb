class MapPlace < ActiveRecord::Base

CATEGORY_NAMES = {
  PR: 'Private Residence',
  NF: 'National Forest',
  SP: 'State Park',
  CP: 'County Park',
  CITY: 'City Park',
  PL: 'Parking Lot',
  PP: 'Private RV Park',
  NP: 'National Park',
  CC: 'County Park',
  ARMY: 'Army Corps of Engineers',
  MFW: 'Montana Fish & Wildlife',
  SF: 'State Forest Campground',
  BLMB: 'BLM Boondocking',
  BLM: 'BLM Campground',
  SPB: 'State Park Boondocking',
  NFB: 'National Forest Boondocking',
  NPB: 'National Park Boondocking'
};

  belongs_to :map

  default_scope { order('arrived ASC') }

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
    i.price_total = i.price * i.stay_length
  end

  def category_name
    CATEGORY_NAMES[self.category.to_sym]
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
end
