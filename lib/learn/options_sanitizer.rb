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
      SANITIZE_LIST.each do |existing, replacement|
        args[existing] = replacement
      end

      args
    end
  end
end
