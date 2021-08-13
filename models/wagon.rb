# frozen_string_literal: true

require_relative('../modules/manufacturer')
require_relative('../modules/object_validator')

WAGON_NUMBER_TEMPLATE = /^\d+$/.freeze

class Wagon
  attr_reader :number

  include Manufacturer
  extend ObjectValidator

  def initialize(number)
    @number = number
    validate!
  end

  private

  def validate!
    raise 'The number must consist of digits' unless WAGON_NUMBER_TEMPLATE.match?(@number)
  end
end
