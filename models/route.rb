# frozen_string_literal: true

require_relative('../modules/instance_counter')
require_relative('../modules/validation')
require_relative('./station')

class Route
  include InstanceCounter
  include Validation

  attr_reader :starting_station, :end_station, :intermediate_stations

  validate :starting_station, type: Station
  validate :end_station, type: Station

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = []
    validate!
    register_instance
  end

  def intermediate_stations=(station)
    @intermediate_stations << station
  end

  def delete_intermediate_station(station)
    @intermediate_stations.delete(station)
  end

  def stations
    stations = []
    stations << @starting_station
    @intermediate_stations.each do |intermediate_station|
      stations << intermediate_station
    end
    stations << @end_station
    stations
  end
end
