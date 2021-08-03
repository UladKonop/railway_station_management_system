# frozen_string_literal: true

class CargoWagon < Wagon
  def initialize
    super
    @type = :cargo
  end
end
