# frozen_string_literal: true

require_relative('./wagon')
require_relative('../modules/validation')

class CargoWagon < Wagon
  attr_reader :volume, :occupied_volume

  include Validation

  validate :number, presence: true, format: /^\d+$/

  def initialize(number, volume)
    super(number)
    @type = :cargo
    @volume = volume
    @occupied_volume = 0.0
    validate!
  end

  def free_volume_amount
    @volume - @occupied_volume
  end

  def occupy_volume(volume_to_occupy)
    if (free_volume_amount - volume_to_occupy).negative?
      p 'There are no more available volume!'
    else
      @occupied_volume += volume_to_occupy
    end
  end
end
