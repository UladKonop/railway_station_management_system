# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attribute_name, options = {})
      @validations = []
      options.each_pair do |key, value|
        @validations << { variable: attribute_name, validation_type: key, option: value }
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@validations).each do |validation|
        variable = instance_variable_get("@#{validation[:variable]}".to_sym)
        case validation[:validation_type]
        when :presence
          check_presence(variable, validation[:variable])
        when :format
          check_format(variable, validation[:option])
        when :type
          check_type(variable, validation[:variable], validation[:option])
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError => e
      p e.message
      false
    end
  end

  private

  def check_presence(variable, variable_name)
    if variable.nil?
      raise "#{self.class}.#{variable_name} shouldn't be nil"
    elsif variable.empty?
      raise "#{self.class}.#{variable_name} shouldn't be empty"
    end
  end

  def check_format(variable, regex)
    unless variable.match?(regex)
      raise "Incorrect format! Should match: #{regex.inspect}"
    end
  end

  def check_type(variable, variable_name, type)
    unless variable.instance_of?(type)
      raise "Wrong type! #{self.class}.#{variable_name} should be #{type}"
    end
  end
end
