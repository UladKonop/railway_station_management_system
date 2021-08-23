# frozen_string_literal: true

require_relative('./wagon')

class PassengerWagon < Wagon
  attr_reader :seats_amount, :occupied_seats

  def initialize(number, seats_amount)
    super(number)
    @type = :passenger
    @seats_amount = seats_amount
    @occupied_seats = 0
  end

  def free_seats_amount
    @seats_amount - @occupied_seats
  end

  def occupy_seat
    if (free_seats_amount - 1).negative?
      p 'There are no more available seats!'
    else
      @occupied_seats += 1
    end
  end
end
