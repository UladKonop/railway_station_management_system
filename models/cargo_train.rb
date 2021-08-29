# frozen_string_literal: true

require_relative('./train')
require_relative('../modules/validation')

class CargoTrain < Train
  include Validation

  validate :number, presence: true, format: /^\w{3}-{0,1}\w{2}/

  def initialize(number)
    super(number)
    @type = :cargo
    validate!
  end
end
