require 'active_support/all'
require 'active_model'


module ActiveModel
  module Validations
    module ClassMethods
      alias_method :__validates_with, :validates_with
      def validates_with(*args, &block)

        _if = Array(args[1][:if])

        # if multiple attribute names are supplied we need to split them into separate validates_with calls
        # in order to be able to choose only relevant validations to certain fields
        args[1][:attributes].each do |attr_name|
          args[1][:attributes] = [attr_name]
          args[1][:if] = _if.clone
          args[1][:if].unshift -> do
            if @__validate_only.present?
              @__validate_only.include?(attr_name)
            elsif @__validate_except.present?
              ! @__validate_except.include?(attr_name)
            else
              true
            end
          end
          __validates_with(*args, &block)
        end
      end
    end

    def validate_only(*fields)
      @__validate_except = nil
      @__validate_only = fields.map &:to_sym
      true
    end

    def validate_except(*fields)
      @__validate_only = nil
      @__validate_except = fields.map &:to_sym
      true
    end

    def validate_all
      @__validate_only = nil
      @__validate_except = nil
      true
    end

  end
end
