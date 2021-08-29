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

    private

    def check_presence(object)
      if object.instance_variable_get("@#{@attribute_name.to_s}".to_sym).nil?
        raise "#{object.class}.#{@attribute_name} shouldn't be nil"
      elsif object.instance_variable_get("@#{@attribute_name.to_s}".to_sym).empty?
        raise "#{object.class}.#{@attribute_name} shouldn't be empty"
      end
    end

    def check_format(object)
      unless @options[:format].match?(object.instance_variable_get("@#{@attribute_name}".to_sym))
        raise "Incorrect format! Should match: #{@options[:format]}"
      end
    end

    def check_type(object)
      unless object.instance_variable_get("@#{@attribute_name}".to_sym).instance_of?(@options[:type])
        raise "Wrong type! #{object.class}.#{@attribute_name} should be #{@options[:type]}"
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@options).compact.each_key do |key|
        case key
        when :presence
          self.class.send(:check_presence, self)
        when :format
          self.class.send(:check_format, self)
        when :type
          self.class.send(:check_type, self)
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
end
