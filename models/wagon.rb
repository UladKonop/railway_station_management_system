# frozen_string_literal: true

require_relative('../modules/manufacturer')
require_relative('../modules/object_validator')

class Wagon
  WAGON_NUMBER_TEMPLATE = /^\d+$/.freeze
  VALIDATION_MESSAGE = 'The number must consist of digits'

  attr_reader :number

  include Manufacturer
  extend ObjectValidator

  def initialize(number)
    @number = number
    validate!
  end

  private

  def validate!
    raise VALIDATION_MESSAGE unless WAGON_NUMBER_TEMPLATE.match?(@number)
  end
end
