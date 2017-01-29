require 'helper'
require 'fluent/test/driver/output'

class TCPClientOutputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
    @port = rand(20000..30000)
    start_stub_socket(@port)
  end

  teardown do
    stop_stub_socket
  end

  def create_driver(conf = '')
    Fluent::Test::Driver::Output.new(Fluent::Plugin::TCPClientOutput).configure(conf)
  end

  sub_test_case 'configure' do
    test 'check default' do
      assert_nothing_raised do
        d = create_driver
        assert { d.instance.formatter.is_a? Fluent::Plugin::JSONFormatter }
      end
    end
  end

  sub_test_case "test output" do
    def output(msgs = [''])
      config = %[
        host localhost
        port #{@port}
        <format>
          @type json
        </format>
        <buffer>
          @type memory
          flush_mode immediate
        </buffer>
      ]

      d = create_driver(config)
      t = event_time("2011-01-02 13:14:15.123")

      d.run(default_tag: 'test') do
        msgs.each do |m|
          d.feed(t, m)
        end
      end

      d.formatted
    end

    test 'typical usage' do
      msgs = [{'a' => 1},{'a' => 2}]
      output(msgs)
    end
  end

  def start_stub_socket(port)
    @server = TCPServer.new(port)
    @stub_running = true

    Thread.start do
      while(@stub_running) do
        Thread.start(server.accept) do |client|
          while (b = client.read)
            puts ">> #{b}"
          end

          client.close
        end
      end
    end

    server.close rescue nil
  end

  def stop_stub_socket
    @stub_running = false
  end
end
