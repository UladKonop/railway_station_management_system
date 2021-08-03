# frozen_string_literal: true

class PassengerWagon < Wagon
  def initialize
    super
    @type = :passenger
  end
end
