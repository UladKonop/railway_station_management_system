# frozen_string_literal: true

class PassengerTrain < Train
  def initialize
    super
    @type = :passenger
  end
end
