# frozen_string_literal: true

require_relative('./route')
require_relative('./station')
require_relative('../modules/manufacturer')
require_relative('../modules/accessors')

class Train
  include Manufacturer
  extend Accessors

  attr_reader :number, :type, :wagons, :route

  strong_attr_accessor :speed, Integer

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    self.class.all << self
  end

  def return_wagons_for_print(&block)
    @wagons.each(&block)
  end

  def self.all
    @@all ||= []
  end

  def self.find(train_number)
    @@all.select { |train| train.number == train_number }
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    if @speed.zero?
      self.wagons = wagon
    else
      p 'Please, stop the train first!'
    end
  end

  def delete_wagon(wagon)
    if @speed.zero?
      wagons.delete_at(wagons.index(wagon))
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
    if current_station != @route.stations.last
      @route.stations[@route.stations.index(current_station) + 1]
    end
  end

  def previous_station
    if current_station != @route.stations.first
      @route.stations[@route.stations.index(current_station) - 1]
    end
  end

  def move(direction)
    case direction
    when :forward
      next_station ? move_train_forward : 'The train is already at the final station!'
    when :backwards
      previous_station ? move_train_backwards : 'The train is already at the first station!'
    end
  end

  private

  def wagons=(wagon)
    @wagons << wagon
  end

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
