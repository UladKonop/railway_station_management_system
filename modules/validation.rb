# frozen_string_literal: true

module Validation
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end
  
    module ClassMethods
      def validate(object, attribute_name, options = {})
        @object = object
        @attribute_name = attribute_name        
        @options = {
          presence: options[:presence] || nil, 
          format: options[:format] || nil, 
          type: options[:type] || nil
        }
        
        @options.compact!.each_key do |key| 
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
      
      private
      
      def check_presence
        if @object.instance_variable_get("@#{@attribute_name.to_s}".to_sym).nil?
          raise "#{@object.class}.#{@attribute_name.to_s} shouldn't be nil"
        elsif @object.instance_variable_get("@#{@attribute_name.to_s}".to_sym) == ''
          raise "#{@object.class}.#{@attribute_name.to_s} shouldn't be empty"
        end
      end

      def check_format
        raise "Incorrect format! Should match: #{@options[:format]}" unless @options[:format].match?(@object.instance_variable_get("@#{@attribute_name.to_s}".to_sym))
      end

      def check_type
      end
    end
  
    module InstanceMethods
      def validate!(attribute_name, options = {})
        self.class.validate(self, attribute_name, options)
      end
      def valid?
      end
    end
  end
  