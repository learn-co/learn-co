module Learn
  class CLI < Thor
    desc "test [options]", "run a lesson's test suite"
    def test(opts=nil)
      system("learn-test #{opts}")
    end
  end
end
