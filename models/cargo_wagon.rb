# frozen_string_literal: true

require_relative('./wagon')

class CargoWagon < Wagon
  def initialize(number, volume)
    super(number)
    @type = :cargo
    @volume = volume
  end
end
