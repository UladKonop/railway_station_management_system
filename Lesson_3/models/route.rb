# frozen_string_literal: true

require_relative('./station')

class Route
  attr_reader :starting_station, :end_station, :intermediate_stations, :full_route

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = {}
    @full_route = {}
    make_full_route
  end

  def intermediate_stations=(station)
    @intermediate_stations.store(station.name, station)
  end

  def delete_intermediate_station(station)
    @intermediate_stations.delete(station.name)
  end

  def make_full_route
    @full_route = {}
    @full_route.store(@starting_station.name, @starting_station)
    @intermediate_stations.each do |intermediate_station|
      @full_route.store(intermediate_station.first, intermediate_station.last)
    end
    @full_route.store(@end_station.name, @end_station)
    # @full_route = @full_route.flatten.compact
  end
end
