# frozen_string_literal: true

require_relative 'typhoon/version'
require 'typhoon/typhoon'
require 'typhoon/concerns/configurable'
require 'typhoon/configuration'

module Typhoon
  class TyphoonError < StandardError; end

  class AlreadyExists < TyphoonError; end

  class NotFound < TyphoonError; end

  class MissingCloudflared < TyphoonError; end

  class MissingConfigurator < TyphoonError; end

  (Typhoon.public_methods - Object.public_methods).each do |m|
    # Send all methods to Typhoon class
    define_singleton_method m do |*args, **kwargs, &block|
      Typhoon.send(m, *args, **kwargs, &block)
    end
  end

end
