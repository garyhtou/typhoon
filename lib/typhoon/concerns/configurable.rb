# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/inflector'

module Typhoon::Concerns
  module Configurable
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :configurator
      attr_writer :configuration

      def configuration
        @configuration ||= reset
      end

      def reset
        @configuration = configurator.new
      end

      def configure
        yield configuration
      end

      def configurator
        raise Typhoon::MissingConfigurator unless @configurator

        @configurator
      end

      private

      def configurator=(value)
        @configurator = value
      end

      def configure_with(value)
        self.configurator = value
      end

    end
  end
end
