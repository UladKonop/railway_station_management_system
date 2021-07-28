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
    @route = route
    @route.first.trains = self
  end
end
