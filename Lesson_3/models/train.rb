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
    @route = route
    @route.first.trains = self
  end

  def nearest_stations
    index = 0
    current_index = 0
    @route.each do |station|
      current_index = index if @number == station.trains[@number]&.number
      index += 1
    end
    previous_index = current_index - 1
    next_index = current_index + 1

    route_array = @route

    if previous_index.negative?
      {
        current_station: route_array[current_index],
        next_station: route_array[next_index]
      }
    elsif next_index == @route.size
      {
        previous_station: route_array[previous_index],
        current_station: route_array[current_index]
      }
    else
      {
        previous_station: route_array[previous_index],
        current_station: route_array[current_index],
        next_station: route_array[next_index]
      }
    end
  end

  def move(direction)
    near_stations = nearest_stations
    case direction
    when :forward
      near_stations[:next_station] ? move_train_forward : 'The train is already at the final station!'
    when :backwards
      near_stations[:previous_station] ? move_train_backwards : 'The train is already at the first station!'
    else
      p 'Train can only move :forward and :backwards!'
    end
  end

  private

  def move_train_forward
    next_station_index = 0
    @route.each_with_index do |station, index|
      if @number == station.trains[@number]&.number
        @route[index].trains.delete(@number)
        next_station_index = index + 1
      end
    end
    @route[next_station_index].trains.store(@number, self)
  end

  def move_train_backwards
    previous_station_index = 0
    @route.each_with_index do |station, index|
      if @number == station.trains[@number]&.number
        @route[index].trains.delete(@number)
        previous_station_index = index - 1
      end
    end
    @route[previous_station_index].trains.store(@number, self)
  end

end
