# frozen_string_literal: true

require_relative('../modules/manufacturer')

class Wagon
  attr_reader :number

  include Manufacturer

  def initialize(number)
    @number = number
  end
end
