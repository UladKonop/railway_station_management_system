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

  def trains_types
    cargos = 0
    passengers = 0
    @trains.each_value do |train|
      if train.type == :cargo
        cargos += 1
      else
        passengers += 1
      end
    end
    { cargos: cargos, passengers: passengers }
  end

  def send_train(train, station)
    delete_train(train)
    station.trains = train
  end
end
