class MapDecorator < Draper::Decorator
  delegate_all

  def num_places
    object.map_places.count
  end

  def num_nights
    object.map_places.sum(:stay_length)
  end

  def num_free_nights
    object.map_places.where(price: 0).sum(:stay_length)
  end

  def percentage_free_nights
    (num_free_nights.to_f / num_nights.to_f) * 100
  end

  def per_night_fee
    object.map_places.all.collect { |i| i.price_adjusted * i.stay_length }.sum.to_f / num_nights
  end

  def most_exspensive
    object.map_places.reorder('price DESC').first
  end

  def consecutive_free
    free_days_max = 0
    free_days_current = 0
    object.map_places.find_each do |mp|
      if mp.price == 0
        free_days_current = free_days_current + mp.stay_length
        free_days_max = free_days_current if free_days_current > free_days_max
      else
        free_days_current = 0
      end
    end
    free_days_max
  end

  def walmart_count
    object.map_places.where("title like '%Walmart%'").count
  end

  def current_state
    @_current_state ||= object.map_places.last.state
  end

  def current_state_face
    STATE_FACE[current_state]
  end

  def current_state_stay
    object.map_places.where(state: current_state).where('arrived > ?', 1.year.ago).sum(:stay_length)
  end

  def path
    object.info_tracks
  end

  def path_points
    # MapPlace.select { |mp| mp.arrival_path.include?([s[0].to_s, s[1].to_s]) }
  end

  def miles_towed
    object.map_places.sum(:arrival_distance).round.to_i
  end

  def average_towed
    miles_towed.to_f / object.map_places.count.to_f
  end

  def longest_arrival_distance
    object.map_places.unscoped.order('arrival_distance DESC').first
  end

  def shortest_arrival_distance
    object.map_places.unscoped.order('arrival_distance ASC').where('arrival_distance != 0').first
  end

end
