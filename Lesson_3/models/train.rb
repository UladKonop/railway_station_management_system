# frozen_string_literal: true

require_relative('./route')
require_relative('./station')

class Train
  attr_reader :number, :type, :wagons_amount, :route

  attr_accessor :speed

  def initialize(number, type, wagons_amount)
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
    @route.stations.first.trains << self
  end

  def current_station
    @route.stations.find do |station|
      return station if station.trains.include?(self)
    end
    nil
  end

  def next_station
    @route.stations[@route.stations.index(current_station) + 1] if current_station != @route.stations.last
  end

  def previous_station
    @route.stations[@route.stations.index(current_station) - 1] if current_station != @route.stations.first
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
    next_station.trains = self
    current_station.delete_train(self)
  end

  def move_train_backwards
    tmp_station = current_station
    previous_station.trains = self
    tmp_station.delete_train(self)
  end
end
