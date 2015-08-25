module Learn
  module TeamMembers
    class Parser
      attr_accessor :members_list

      def initialize(members_list)
        @members_list = members_list
      end

      def execute
        parse_members
        return_message
      end

      private

      def parse_members
        self.members_list = self.members_list.gsub(/,\s*/, ' ').gsub(/\s{2,}/, ' ').split(' ').map(&:strip)

        if !self.members_list.all? {|m| m.start_with?('@')}
          self.members_list.each {|m| m.unshift('@') if !m.start_with?('@')}
        end
      end

      def return_message
        "team: #{self.members_list.join(' ')}"
      end
    end
  end
end
