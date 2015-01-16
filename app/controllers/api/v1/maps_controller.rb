class Api::V1::MapsController < ApplicationController

  before_filter :find_map, only: [:show, :d3_current, :infographic]
  def show
    render 'api/v1/maps/d3_map'
  end

  def d3_current
    render 'api/v1/maps/d3_map_current'
  end

  def infographic
    @states = Calculations::States.new(@map).data
    @categories = Calculations::Categories.new(@map).data

    @map = MapDecorator.decorate(@map)
    render 'api/v1/maps/infographic'
  end


  def find_map
    @map = Map.find params[:id]
  end

end
