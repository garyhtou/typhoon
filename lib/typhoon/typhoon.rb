# frozen_string_literal: true

require 'typhoon/cloudflared'
require 'typhoon/configuration'
require 'socket'

module Typhoon
  # This class could really use a better name
  class Typhoon
    include Concerns::Configurable
    configure_with ::Typhoon::Configuration

    def initialize(name)
      @name = name
      raise NotFound unless self.class.exists? name
    end

    def self.find(name)
      new(name)
    end

    def self.list
      out = Cloudflared.run!('tunnel list')
      lines = out.split("\n")
      lines.shift # remove message
      headers = lines.shift.split

      lines.map do |l|
        id, name, created, conn = l.split

        conn = conn&.split(',')&.map do |c|
          num, loc = c.split('x')
          { location: loc, quantity: num.to_i }
        end

        { id: id, name: name, created: created, connections: conn }
      end
    end

    def self.create(name: nil, hostname:, force: false)
      name ||= hostname.split('.').first
      raise AlreadyExists if exists? name && !force

      # Create tunnel
      Cloudflared.run!("tunnel create #{name}")

      # Map DNS name to tunnel
      cmd = "tunnel route dns #{name} #{hostname}"
      cmd += ' -f' if force
      Cloudflared.run!(cmd)
    end

    def info
      Cloudflared.run!("tunnel info #{@name}")
    end

    def start(port: nil, hostname: 'localhost')
      port ||= self.class.find_port
      Cloudflared.run!("tunnel run --url #{hostname}:#{port} #{@name}")
    end

    def delete(force: false)
      cleanup

      cmd = "tunnel delete #{@name}"
      cmd += ' -f' if force
      Cloudflared.run!(cmd)

      # The DNS record still lingers. The cloudflared CLI doesn't provide a way
      # to delete it :(
    end

    def cleanup
      Cloudflared.run! "tunnel cleanup #{@name}"
    end

    def self.version
      ::Typhoon::VERSION
    end

    def self.exists?(name)
      list.find { |t| t[:name] == name }
    end

    private

    def self.find_port(hostname: 'localhost')
      # TODO: try to find a reasonable open (used) port
      configuration.default_port || 3000
    end
  end
end
