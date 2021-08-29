# frozen_string_literal: true

require_relative('../modules/instance_counter')
require_relative('../modules/validation')

class Station
  include InstanceCounter
  include Validation
  
  attr_reader :name, :trains
  validate :name, presence: true

  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
    validate!
    register_instance
  end

  def return_trains_for_print(&block)
    @trains.each(&block)
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
