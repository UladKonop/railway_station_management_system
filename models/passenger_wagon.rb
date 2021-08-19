# frozen_string_literal: true

require_relative('./wagon')

class PassengerWagon < Wagon
  attr_reader :seats_amount

  def initialize(number, seats_amount)
    super(number)
    @type = :passenger
    @seats_amount = seats_amount
    @occupied_seats = 0
  end
end
