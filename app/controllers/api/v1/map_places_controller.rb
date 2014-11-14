class Api::V1::MapPlacesController < ApplicationController
  respond_to :json
  before_filter :load_map

  def index
    @map_places = @map.map_places
    #render json: @map_places
  end



  private

  def load_map
    @map ||= Map.find params[:map_id]
  end


end
