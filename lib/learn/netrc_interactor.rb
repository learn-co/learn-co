require 'netrc'

module Learn
  class NetrcInteractor
    attr_reader :login, :password, :netrc

    def initialize
      ensure_proper_permissions!
    end

    def read(machine: 'learn-config')
      @netrc = Netrc.read
      @login, @password = netrc[machine]
    end

    def write(machine: 'learn-config', new_login:, new_password:)
      netrc[machine] = new_login, new_password
      netrc.save
    end

    def delete!(machine:)
      @netrc = Netrc.read

      netrc.delete(machine)
      netrc.save
    end

    private

    def ensure_proper_permissions!
      system('chmod 0600 ~/.netrc &>/dev/null')
    end
  end
end
