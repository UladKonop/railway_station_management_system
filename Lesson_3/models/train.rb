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

  def current_station
    @route.each do |station|
      binding.irb
      return station if @number == station.trains[@number]&.number
    end
  end

  def next_station
    @route.each_with_index do |station, index|
      if station == current_station
        if @route[index + 1]
          return @route[index + 1]
        else
          p 'The next station does not exist'
        end
      end
    end
  end

  def previous_station
    @route.each_with_index do |station, index|
      if station == current_station
        if @route[index - 1]
          return @route[index - 1]
        else
          p 'The previous station does not exist'
        end
      end
    end
  end

  def move(direction)
    case direction
    when :forward
      next_station ? move_train_forward : 'The train is already at the final station!'
    when :backwards
      previous_station ? move_train_backwards : 'The train is already at the first station!'
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
