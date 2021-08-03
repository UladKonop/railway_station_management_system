# frozen_string_literal: true

class CargoTrain < Train
  def initialize
    super
    @type = :cargo
  end
end
