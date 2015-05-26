module Learn
  class CLI < Thor
    desc '[test] [options]', "Run a lesson's test suite"
    long_desc <<-LONGDESC
      `learn [test] [options]` will run your lesson's test suite.

      You can supply the following options when running Jasmine tests:

      -n, --[no-]color  # Turn off color output
      \x5 -l, --local       # Don't push results to Learn
      \x5 -b, --browser     # Run tests in browser
      \x5 -o, --out FILE    # Specify an output file
      \x5 -s, --skip        # Don't run dependency checks

      When running an RSpec test suite, all normal RSpec options can be
      passed in.
    LONGDESC
    def test(*opts)
      system("learn-test #{opts.join(' ')}")
    end

    desc 'version, -v, --version', 'Display the current version of the Learn gem'
    def version
      puts Learn::VERSION
    end

    desc 'submit ["message"]', 'Submit your completed lesson'
    long_desc <<-LONGDESC
      `learn submit ["message"]` will submit your lesson to Learn.

      It will add your changes, commit them, push to GitHub, and issue a pull request.
    LONGDESC
    def submit(*opts)
      system("learn-submit #{opts.join(' ')}")
    end

    desc "open lab_name [--editor=editor_binary]", "Open the given lab [with your editor]"
    option :editor, required: false, type: :string, aliases: ['e']
    def open(*lab_name)
      lab_name = Learn::Lab::Parser.new(lab_name.join(' ')).parse!
      editor = options[:editor]

      system("learn-open #{lab_name} #{editor}")
    end

    desc 'whoami', 'Display your Learn gem configuration information'
    def whoami
      system('learn-config --whoami')
    end

    desc 'reset', 'Reset your Learn gem configuration'
    def reset
      system('learn-config --reset')
    end

    desc 'directory', 'Set your local Learn directory. Defaults to ~/Development/code'
    def directory
      system('learn-config --set-directory')
    end
  end
end
