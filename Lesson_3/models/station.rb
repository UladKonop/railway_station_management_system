# frozen_string_literal: true

require_relative('./train')

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = {}
  end

  def trains=(train)
    @trains.store(train.number, train)
  end

  def delete_train(train)
    @trains.delete(train.number)
  end

  def trains_by_type(type)
    @trains.select { |_number, train| train.type == type }.to_a
  end
end
