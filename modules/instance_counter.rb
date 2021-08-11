# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def count_instance
      self.instances = instances.to_i + 1
    end
  end

  module InstanceMethods
    def register_instance
      self.class.count_instance
    end
  end
end
