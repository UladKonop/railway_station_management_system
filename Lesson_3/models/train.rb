# frozen_string_literal: true

require_relative('./route')

class Train
  attr_reader :number, :type, :wagons_amount, :route

  attr_accessor :speed, :current_station

  def initialize(number, type, wagons_amount)
    return nil unless (type == :cargo) || (type == :passenger)

    @number = number
    @type = type
    @wagons_amount = wagons_amount
    @speed = 0
  end

  def stop
    @speed = 0
  end

  def change_wagon_amount(amount)
    if @speed.zero?
      @wagons_amount += amount
    else
      p 'Please, stop the train first!'
    end
  end

  def route=(route)
    @route = route.clone
    @route.first.last.trains = self
  end

  def nearest_stations
    index = 0

    @route.each_value { |station| index += 1 if @number == station.trains[@number]&.number }

    current_index = index - 1
    previos_index = current_index - 1
    next_index = current_index + 1

    route_array = @route.to_a

    if previos_index.negative?
      {
        current_station: route_array[current_index].first,
        next_station: route_array[next_index].first
      }
    elsif next_index > @route.size
      {
        previos_station: route_array[previos_index].first,
        current_station: route_array[current_index].first
      }
    else
      {
        previos_station: route_array[previos_index].first,
        current_station: route_array[current_index].first,
        next_station: route_array[next_index].first
      }
    end
  end
end
