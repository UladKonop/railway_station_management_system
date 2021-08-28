# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    # base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        raise TypeError, 'method name is not symbol' unless name.is_a?(Symbol)

        variable_name_symbol = "@#{name}".to_sym
        variable_name_array_symbol = "@#{name}_array".to_sym

        define_method(name) { instance_variable_get(variable_name_symbol) }
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(variable_name_symbol, value)
          if instance_variable_get(variable_name_array_symbol).nil?
            instance_variable_set(variable_name_array_symbol, [])
          end
          instance_variable_get(variable_name_array_symbol) << value
        end

        define_method("#{name}_history".to_sym) do
          instance_variable_get(variable_name_array_symbol)
        end
      end
    end

    def strong_attr_accessor; end
  end

  # module InstanceMethods
  # end
end
