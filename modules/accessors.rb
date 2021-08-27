# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    # base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*method_names)
      # p attrs.inspect
      method_names.each do |method_name|
        variable_name = "@#{method_name}".to_sym
        # define_method("#{method_name}_history".to_sym){ |value| }
        define_method(method_name) { instance_variable_get(variable_name) }
        define_method("#{method_name}=".to_sym) { |value| instance_variable_set(variable_name, value) }
      end
    
    end

    def strong_attr_accessor; end
  end

  # module InstanceMethods
  # end
end
