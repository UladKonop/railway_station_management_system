# frozen_string_literal: true

require_relative('./wagon')

class PassengerWagon < Wagon
  def initialize(number, seats_amount)
    super(number)
    @type = :passenger
    @seats_amount = seats_amount
  end
end
