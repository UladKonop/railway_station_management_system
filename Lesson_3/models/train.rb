# frozen_string_literal: true

require_relative('./route')

class Train
  attr_reader :number, :type, :wagons_amount, :route

  attr_accessor :speed

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
    current_index = 0
    @route.each_value do |station|
      current_index = index if @number == station.trains[@number]&.number
      index += 1
    end
    previous_index = current_index - 1
    next_index = current_index + 1

    route_array = @route.to_a

    if previous_index.negative?
      {
        current_station: route_array[current_index].first,
        next_station: route_array[next_index].first
      }
    elsif next_index == @route.size
      {
        previous_station: route_array[previous_index].first,
        current_station: route_array[current_index].first
      }
    else
      {
        previous_station: route_array[previous_index].first,
        current_station: route_array[current_index].first,
        next_station: route_array[next_index].first
      }
    end
  end

  def move(direction)
    near_stations = nearest_stations
    case direction
    when :forward
      if near_stations[:next_station]
        @route.each_value do |station|
          @route[station.name].trains.delete(@number) if @number == station.trains[@number]&.number
        end
        @route[near_stations[:next_station]].trains.store(@number, self)
      else
        p 'The train is already at the final station!'
      end
    when :backwards
      if near_stations[:previous_station]
        @route.each_value do |station|
          station.trains.delete(@number) if @number == station.trains[@number]&.number
        end
        @route[near_stations[:previous_station]].trains.store(@number, self)
      else
        p 'The train is already at the first station!'
      end
    else
      p 'Train can only move :forward and :backwards!'
    end
  end
end
