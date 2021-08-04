# frozen_string_literal: true

require_relative('./wagon')

class PassengerWagon < Wagon
  def initialize(number)
    super(number)
    @type = :passenger
  end
end
