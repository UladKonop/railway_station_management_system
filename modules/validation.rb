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
        case validation[:validation_type]
        when :presence
          check_presence(validation[:variable])
        when :format
          check_format(validation[:variable], validation[:option])
        when :type
          check_type(validation[:variable], validation[:option])
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

  def check_presence(variable)
    if instance_variable_get("@#{variable}".to_sym).nil?
      raise "#{self.class}.#{variable} shouldn't be nil"
    elsif instance_variable_get("@#{variable}".to_sym).empty?
      raise "#{self.class}.#{variable} shouldn't be empty"
    end
  end

  def check_format(variable, regex)
    unless instance_variable_get("@#{variable}".to_sym).match?(regex)
      raise "Incorrect format! Should match: #{regex.inspect}"
    end
  end

  def check_type(variable, type)
    unless instance_variable_get("@#{variable}".to_sym).instance_of?(type)
      raise "Wrong type! #{self.class}.#{variable} should be #{type}"
    end
  end
end
