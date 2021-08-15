# frozen_string_literal: true

require_relative('../modules/instance_counter')
require_relative('../modules/object_validator')

class Station
  attr_reader :name, :trains

  include InstanceCounter
  extend ObjectValidator

  def initialize(name)
    @name = name.to_s
    @trains = []
    self.class.all << self
    validate!
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

  private

  def validate!
    raise 'The station name must consist of at least one character' unless @name.size >= 1
  end
end
