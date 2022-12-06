# frozen_string_literal: true

require 'mkmf'
require 'typhoon/concerns/configurable'
require 'typhoon/cloudflared/configuration'

module Typhoon
  module Cloudflared
    include Concerns::Configurable
    configure_with Cloudflared::Configuration

    class << self
      def run!(command = nil)
        raise MissingCloudflared unless installed?

        run(command || yeild)
      end

      def logged_in?
        # TODO
        run!('tunnel login')
      end

      def version
        @version ||= installed? && run('-v').split[2]
      end

      def installed?
        @installed ||= !!path && run('-v').start_with?('cloudflared version')
      end

      def path
        # The `find_executable0` method doesn't polute the stdout with messages
        @path ||= find_executable0 'cloudflared'
      end

      private

      def run(command = nil)
        command ||= yeild
        cmd = path

        # Global options
        cmd += " --credentials-file #{configuration.tunnel_cert_path}" if configuration.tunnel_cert_path

        `#{cmd} #{command}`.strip
      end
    end
  end
end
