require 'pry'

module Learn
  class OptionsSanitizer
    attr_reader :args

    SANITIZE_LIST = {
      '-e' => '--editor'
    }

    def initialize(args)
      @args = args
    end

    def sanitize!
      binding.pry
      SANITIZE_LIST.each do |existing, replacement|
        if args[existing]
          args[existing] = replacement
        end
      end

      args
    end
  end
end
