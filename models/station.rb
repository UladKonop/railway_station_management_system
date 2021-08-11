# frozen_string_literal: true

require_relative('../modules/instance_counter')

class Station
  attr_reader :name, :trains

  include InstanceCounter

  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
    register_instance
  end

  def self.all
    @all ||= []
  end

  def trains=(train)
    @trains << train
  end

  def delete_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end
