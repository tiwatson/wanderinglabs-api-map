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
    object.map_places.all.collect { |i| i.price * i.stay_length }.sum.to_f / num_nights
  end

  def most_exspensive
    object.map_places.reorder('price DESC').first
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
    object.map_places.where(state: current_state).sum(:stay_length)
  end

end
