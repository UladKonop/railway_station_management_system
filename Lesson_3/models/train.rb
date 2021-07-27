# frozen_string_literal: true

class Train
  attr_reader :name, :type
  attr_accessor :wagons_amount, :speed, :route

  def initialize; end

  def go(direction); end
end
