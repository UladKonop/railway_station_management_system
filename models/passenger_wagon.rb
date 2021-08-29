# frozen_string_literal: true

require_relative('./wagon')
require_relative('../modules/validation')

class PassengerWagon < Wagon
  attr_reader :seats_amount, :occupied_seats
  include Validation

  validate :number, presence: true, format: /^\d+$/
  validate :volume, presence: true

  def initialize(number, seats_amount)
    super(number)
    @type = :passenger
    @seats_amount = seats_amount
    @occupied_seats = 0
    validate!
  end

  def free_seats_amount
    @seats_amount - @occupied_seats
  end

  def occupy_seat
    if (free_seats_amount - 1).negative?
      p 'There are no more available seats!'
    else
      @occupied_seats += 1
    end
  end
end
