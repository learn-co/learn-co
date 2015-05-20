module Learn
  class CLI < Thor
    desc "[test] [options]", "Run a lesson's test suite"
    long_desc <<-LONGDESC
      `learn [test] [options]` will run your lesson's test suite.

      You can supply the following options when running Jasmine tests:

      \x20 -n, --[no-]color  # Turn off color output
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

    desc "version, -v, --version", "Display the current version of the Learn gem"
    def version
      puts Learn::VERSION
    end

    desc "submit", "Submit your completed lesson"
    def submit
      puts "Coming soon!"
      exit
    end

    desc "open lab_name [--editor editor_binary]", "Open the given lab [with your editor]"
    option :editor, required: false, type: :string
    def open(*lab_name)
      lab_name = Learn::Lab::Parser.new(lab_name.join(' ')).parse!
      puts lab_name
      puts "Coming soon!"
      exit
    end

    desc "config", "Reconfigure the Learn gem"
    def config
      system("learn-config")
    end
  end
end
