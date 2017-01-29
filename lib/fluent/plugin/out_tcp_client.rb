require 'fluent/plugin/output'

module Fluent::Plugin
  class TCPClientOutput < Output
    Fluent::Plugin.register_output('tcp_client', self)

    helpers :formatter, :compat_parameters

    def initialize
      super
    end

    config_param :host, :string,  default: '127.0.0.1'
    config_param :port, :integer, default: nil

    config_section :format do
      config_set_default :@type, 'json'
    end

    attr_reader :formatter # for testing

    def configure(conf)
      compat_parameters_convert(conf, :formatter)

      super

      @formatter = formatter_create
      @sock = nil
    end

    def start
      super
      connect
    end

    def shutdown
      super
      disconnect
    end

    def format(tag, time, record)
      @formatter.format(tag, time, record)
    end

    def write(chunk)
      connect
      tries ||= 3

      chunk.write_to(@sock)
    rescue => e
      if (tries -= 1) > 0
        reconnect
        retry
      else
        $log.warn("Failed writing data to socket: #{e}")
      end
    end

    #######
    private
    #######

    def connect
      @sock ||= TCPSocket.new(@host, @port)
    end

    def disconnect
      @sock.close rescue nil
      @sock = nil
    end

    def reconnect
      disconnect
      connect
    end
  end
end
