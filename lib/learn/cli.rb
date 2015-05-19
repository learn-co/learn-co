module Learn
  class CLI < Thor
    def test(opts=nil)
      system("learn-test #{opts}")
    end
  end
end
