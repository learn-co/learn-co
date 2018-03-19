module Learn
  class OptionsSanitizer
    attr_reader :args

    SANITIZE_LIST = {
      '-e' => '--editor',
      '-t' => '--template'
    }

    KNOWN_COMMANDS = [
      'test',
      'help',
      'version',
      '-v',
      '--version',
      'submit',
      'open',
      'reset',
      'whoami',
      'directory',
      'next',
      'new',
      'status',
      'lint',
      'hello',
      'save'
    ]

    KNOWN_TEST_FLAGS = [
      '--no-color',
      '-b',
      '--browser',
      '-s',
      '--skip',
      '--sync',
      '--keep',
      '--fail-fast'
    ]

    def initialize(args)
      @args = args
    end

    def sanitize!
      sanitize_non_test_args!
      sanitize_test_args!
    end

    private

    # Sanitization methods
    def sanitize_non_test_args!
      args.map! do |arg|
        SANITIZE_LIST[arg] ? SANITIZE_LIST[arg] : arg
      end
    end

    def sanitize_test_args!
      if missing_or_unknown_args?
        handle_missing_or_unknown_args
      elsif has_test_command_and_invalid_flag?
        exit_with_invalid_flag
      elsif has_test_command_and_output_flag?
        check_for_output_file(add_test_command: false)
      end
    end

    # Arg manipulation methods
    def handle_missing_or_unknown_args
      if first_arg_not_a_flag_or_file?
        exit_with_unknown_command
      elsif has_output_flag? || has_format_flag?
        check_for_output_file if has_output_flag?
        check_for_format_type if has_format_flag?
      elsif only_has_flag_arguments?
        add_test_command
      else
        exit_with_cannot_understand
      end
    end

    def check_for_output_file(add_test_command: true)
      index = args.index('-o') || args.index('--out')

      if flag_argument_specified?(index)
        initial_arg_index = add_test_command ? 0 : 1
        out_arg = "#{args[index]} #{args[index+1]}"
        delete_flag_args!(index)

        if only_has_known_test_flags?(initial_arg_index)
          rebuild_args!(flag_arg: out_arg, add_test_command: add_test_command)
        else
          exit_with_unknown_flags
        end
      else
        exit_with_missing_output_file
      end
    end

    def check_for_format_type(add_test_command: true)
      index = args.index('-f') || args.index('--format')

      if flag_argument_specified?(index)
        initial_arg_index = add_test_command ? 0 : 1
        format_arg = "#{args[index]} #{args[index+1]}"
        delete_flag_args!(index)

        if only_has_known_test_flags?(initial_arg_index)
          rebuild_args!(flag_arg: format_arg, add_test_command: add_test_command)
        else
          exit_with_unknown_flags
        end
      else
        exit_with_missing_format_type
      end
    end

    def delete_flag_args!(index)
      args.delete_at(index+1)
      args.delete_at(index)
    end

    def rebuild_args!(flag_arg:, add_test_command:)
      args.unshift('test') if add_test_command
      args.push(flag_arg)
    end

    def add_test_command
      args.unshift('test')
    end

    # Arg check methods
    def missing_or_unknown_args?
      args.empty? || !KNOWN_COMMANDS.include?(args[0])
    end

    def first_arg_not_a_flag_or_file?
      args[0] && !args[0].start_with?('-') && first_arg_not_a_file?
    end

    def first_arg_not_a_file?
      ['/', '.'].none? { |punct| args[0].include?(punct) } && !File.exists?(args[0])
    end

    def arg_is_a_file?(arg)
      arg && (['/', '.'].any? { |punct| arg.include?(punct) } || File.exists?(arg))
    end

    def has_output_flag?
      args.any? {|arg| ['-o', '--out'].include?(arg)}
    end

    def has_format_flag?
      args.any? {|arg| ['-f', '--format'].include?(arg)}
    end

    def only_has_known_test_flags?(start_index)
      if arg_is_a_file?(args[start_index])
        start_index += 1
      end

      args[start_index..-1].all? {|arg| KNOWN_TEST_FLAGS.include?(arg)}
    end

    def flag_argument_specified?(index)
      args[index+1] && !args[index+1].start_with?('-')
    end

    def only_has_flag_arguments?
      if arg_is_a_file?(args[0])
        args[1..-1].all? {|arg| arg.start_with?('-')}
      else
        args.all? {|arg| arg.start_with?('-')}
      end
    end

    def has_test_command_and_invalid_flag?
      args[0] == 'test' && args[1] && !args[1].start_with?('-') && !arg_is_a_file?(args[1])
    end

    def has_test_command_and_output_flag?
      args[0] == 'test' && args.any? {|arg| ['-o', '--out'].include?(arg)}
    end

    def has_test_command_and_format_flag?
      args[0] == 'test' && args.any? {|arg| ['-f', '--format'].include?(arg)}
    end

    # Exit methods
    def exit_with_invalid_flag
      puts "Invalid flag: #{args[1]}"
      exit
    end

    def exit_with_unknown_command
      puts "Unknown command: #{args[0]}. Type `learn help` to see what you can do."
      exit
    end

    def exit_with_cannot_understand
      puts "Sorry, I can't understand what you're trying to do. Type `learn help` for help."
      exit
    end

    def exit_with_unknown_flags
      unknown_flags = args.select {|arg| !KNOWN_TEST_FLAGS.include?(arg)}
      puts "Unknown #{unknown_flags.count > 1 ? 'flags' : 'flag'}: #{unknown_flags.join(', ')}"
      exit
    end

    def exit_with_missing_output_file
      puts "Must specify an output file when using the -o, --out flag."
      exit
    end

    def exit_with_missing_format_type
      puts "Must specify a format type when using the -f, --format flag."
      exit
    end
  end
end
