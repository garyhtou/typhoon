# frozen_string_literal: true

module Typhoon
  class Configuration
    attr_accessor :default_port

    def cloudflared_configuration
      ::Typhoon::Cloudflared.configuration
    end

    def cloudflared_configuration=(value)
      ::Typhoon::Cloudflared.configuration = value
    end
  end
end
