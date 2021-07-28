# frozen_string_literal: true

require_relative('./station')

class Route
  attr_reader :starting_station, :end_station, :intermediate_stations, :full_route

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = {}
    @full_route = []
    make_full_route
  end

  def intermediate_stations=(station)
    @intermediate_stations.store(station.name, station)
  end

  def delete_intermediate_station(station)
    @intermediate_stations.delete(station.name)
  end

  def make_full_route
    @full_route.push(@starting_station)
    @full_route.push(@intermediate_stations.to_a)
    @full_route.push(@end_station)
    @full_route.flatten!.compact!
  end
end
