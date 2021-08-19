# frozen_string_literal: true

require_relative('./wagon')

class CargoWagon < Wagon
  attr_reader :volume

  def initialize(number, volume)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0
  end
end
