module Learn
  class CLI < Thor
    desc "[test] [options]", "Run a lesson's test suite"
    long_desc <<-LONGDESC
      `learn [test] [options]` will run your lesson's test suite.

      You can supply the following options when running Jasmine tests:

      -n, --[no-]color  # Turn off color output

      -l, --local       # Don't push results to Learn

      -b, --browser     # Run tests in browser

      -o, --out FILE    # Specify an output file for your test results

      -s, --skip        # Don't run dependency checks

      When running an RSpec test suite, all normal RSpec options can be
      passed in.
    LONGDESC
    def test(opts=nil)
      system("learn-test #{opts}")
    end
  end
end
