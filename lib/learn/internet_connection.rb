require 'net/http'
require 'timeout'

module Learn
  class InternetConnection
    attr_accessor :connection

    STATUS_URI          = URI.new('https://learn.co/p/gem_status')
    SUCCESS_STATUS      = 'this is a boring message to prove you can connect to the internet'
    NO_INTERNET_MESSAGE = "It seems like you aren't connected to the internet. All features of the Learn gem may not work properly. Trying anyway..."

    def self.no_internet_connection?
      new.test_connection.connection?
    end

    def initialize
      @connection = false
    end

    def test_connection
      begin
        Timeout::timeout(5) do
          resp = Net::HTTP.get(STATUS_URI)

          if !resp.match(/#{SUCCESS_STATUS}/)
            puts NO_INTERNET_MESSAGE
          end
        end
      rescue Timeout::Error
        puts NO_INTERNET_MESSAGE
      rescue SocketError => e
        if e.message.match(/getaddrinfo: nodename nor servname provided/)
          puts NO_INTERNET_MESSAGE
        end
      end
    end

    def connection?
      !!connection
    end
  end
end
