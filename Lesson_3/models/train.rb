# frozen_string_literal: true

class Train
  attr_reader :number, :type
  # cargo, passenger
  attr_accessor :speed, :route

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

  def go(direction); end
end
