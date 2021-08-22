# frozen_string_literal: true

require_relative('./wagon')

class CargoWagon < Wagon
  attr_reader :volume, :occupied_volume

  def initialize(number, volume)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0
  end

  def free_volume_amount
    @volume - @occupied_volume
  end

  def occupy_volume(volume_to_occupy)
    if (@volume - volume_to_occupy).negative?
      p 'There are no more available volume!'
    else
      @occupied_volume += volume_to_occupy
    end
  end
end
