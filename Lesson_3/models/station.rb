# frozen_string_literal: true

class Station
  attr_reader :name
  attr_accessor :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def types_of_trains; end

  def delete_train(train_number)
    @trains.delete(train_number)
  end
end
