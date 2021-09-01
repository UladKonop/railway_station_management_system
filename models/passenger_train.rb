# frozen_string_literal: true

require_relative('./train')
require_relative('../modules/validation')

class PassengerTrain < Train
  include Validation

  validate :number, presence: true, format: /^\w{3}-{0,1}\w{2}$/

  def initialize(number)
    super(number)
    @type = :passenger
    validate!
  end
end
