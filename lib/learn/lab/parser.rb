module Learn
  module Lab
    class Parser
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def parse!
        if name.chars.include?(' ')
          slugify_name!
        else
          name.downcase.strip
        end
      end

      private

      def slugify_name!
        name.downcase.gsub(' ', '-').strip
      end
    end
  end
end
