# frozen_string_literal: true

module Typhoon::Cloudflared
  class Configuration
    attr_accessor :tunnel_cert_path

    def initialize
      @tunnel_cert_path = nil
    end

  end
end
