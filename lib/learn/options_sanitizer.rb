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
      sanitize_editor_arg!
      sanitize_test_args!
    end

    private

    def sanitize_editor_arg!
      args.map! do |arg|
        SANITIZE_LIST[arg] ? SANITIZE_LIST[arg] : arg
      end
    end

    def sanitize_test_args!
      if args.empty? || args.none? {|arg| KNOWN_COMMANDS.include?(arg)}
        if args[0] && !args[0].start_with?('-')
          puts "Unknown command: #{args[0]}. Type `learn help` to see what you can do."
          exit
        elsif args.any? {|arg| ['-o', '--out'].include?(arg)}
          index = args.index('-o') || args.index('--out')
          if args[index+1] && !args[index+1].start_with?('-')
            out_arg = "#{args[index]} #{args[index+1]}"
            args.delete(args[index])
            args.delete(args[index+1])

            if args.all? {|arg| KNOWN_TEST_FLAGS.include?(arg)}
              args.unshift('test')
              args.push(out_arg)
            else
              unknown_flags = args.select {|arg| !KNOWN_TEST_FLAGS.include?(arg)}
              puts "Unknown #{unknown_flags.count > 1 ? 'flags' : 'flag'}: #{unknown_flags.join(', ')}"
              exit
            end
          else
            puts "Must specify an output file when using the -o, --out flag."
            exit
          end
        elsif args.all? {|arg| arg.start_with?('-')}
          args.unshift('test')
        else
          puts "What?"
          exit
        end
      elsif args[0] == 'test' && args[1] && !args[1].start_with?('-')
        puts "Unknown flag: #{args[1]}"
        exit
      end
    end
  end
end
