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
      args.map do |arg|
        SANITIZE_LIST[arg] ? SANITIZE_LIST[arg] : arg
      end
    end
  end
end
