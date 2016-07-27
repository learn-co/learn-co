require 'net/http'
require 'timeout'
require 'openssl'

module Learn
  class InternetConnection
    attr_accessor :connection
    attr_reader   :silent

    STATUS_URI          = URI('https://learn.co/p/gem_status')
    SUCCESS_STATUS      = 'this is a boring message to prove you can connect to the internet'
    NO_INTERNET_MESSAGE = "It seems like you aren't connected to the internet. All features of the Learn gem may not work properly. Trying anyway..."

    def self.no_internet_connection?
      new.no_connection?
    end

    def self.internet_connection?
      new(silent: true).connection?
    end

    def self.test_connection
      new
    end

    def initialize(silent: false)
      @connection = false
      @silent     = silent

      test_connection
    end

    def test_connection(retries: 3)
      begin
        Timeout::timeout(5) do
          resp = Net::HTTP.get(STATUS_URI)

          if resp.match(/#{SUCCESS_STATUS}/)
            self.connection = true
          else
            self.connection = false
            puts NO_INTERNET_MESSAGE if !silent
          end
        end
      rescue Timeout::Error
        if retries > 0
          test_connection(retries: retries - 1)
        else
          self.connection = false
          puts NO_INTERNET_MESSAGE if !silent
        end
      rescue SocketError => e
        if e.message.match(/getaddrinfo: nodename nor servname provided/)
          if retries > 0
            test_connection(retries: retries - 1)
          else
            self.connection = false
            puts NO_INTERNET_MESSAGE if !silent
          end
        end
      rescue OpenSSL::SSL::SSLError
        self.connection = false
        puts "It looks like your SSL certificates aren't quite right."
        puts "Please run `rvm osx-ssl-certs update all` and then try again."
        exit
      end
    end

    def no_connection?
      !connection
    end

    def connection?
      connection
    end
  end
end
