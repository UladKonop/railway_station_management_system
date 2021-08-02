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
    @route.first.trains << self
  end

  def current_station
    @route.each do |station|
      return station if self == station.trains.select { |train| train.number == @number }.pop
    end
    nil
  end

  def next_station
    @route.each_with_index do |station, index|
      next unless station == current_station
      return @route[index + 1] if index + 1 < @route.size
    end
    false
  end

  def previous_station
    @route.each_with_index do |station, index|
      next unless station == current_station
      return @route[index - 1] if index - 1 >= 0
    end
    false
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
