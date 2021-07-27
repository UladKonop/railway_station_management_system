# frozen_string_literal: true

require_relative('./route')

class Train
  attr_reader :number, :type, :route
  # cargo, passenger
  attr_accessor :speed

  def initialize(name, type, wagons_amount)
    @name = name
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

  def wagons_amount
    @wagons_amount
  end

  def route=(route)
    @routes = {route.name => route}
  end

  def go(direction); end
end
