class Api::V1::MapsController < ApplicationController

  before_filter :find_map, only: [:show, :d3_current]
  def show
    render 'api/v1/maps/d3_map'
  end

  def d3_current
    render 'api/v1/maps/d3_map_current'
  end

  def find_map
    @map = Map.find params[:id]
  end

end
