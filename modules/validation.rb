# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attribute_name, options = {})
      @attribute_name = attribute_name
      @options = {
        presence: options[:presence] || nil,
        format: options[:format] || nil,
        type: options[:type] || nil
      }
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@options).compact.each_key do |key|
        case key
        when :presence
          check_presence
        when :format
          check_format
        when :type
          check_type
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

  def check_presence
    attribute_name = self.class.instance_variable_get(:@attribute_name)

    if instance_variable_get("@#{attribute_name}".to_sym).nil?
      raise "#{self.class}.#{attribute_name} shouldn't be nil"
    elsif instance_variable_get("@#{attribute_name}".to_sym).empty?
      raise "#{self.class}.#{attribute_name} shouldn't be empty"
    end
  end

  def check_format
    attribute_name = self.class.instance_variable_get(:@attribute_name)

    unless self.class.instance_variable_get(:@options)[:format].match?(instance_variable_get("@#{attribute_name}".to_sym))
      raise "Incorrect format! Should match: #{self.class.instance_variable_get(:@options)[:format].inspect}"
    end
  end

  def check_type
    attribute_name = self.class.instance_variable_get(:@attribute_name)

    unless instance_variable_get("@#{attribute_name}".to_sym).instance_of?(self.class.instance_variable_get(:@options)[:type])
      raise "Wrong type! #{self.class}.#{attribute_name} should be #{self.class.instance_variable_get(:@options)[:type]}"
    end
  end
end
