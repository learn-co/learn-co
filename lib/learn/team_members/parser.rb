module Learn
  module TeamMembers
    class Parser
      attr_reader   :full_args
      attr_accessor :members_list

      def initialize(full_args)
        @full_args = full_args
      end

      def execute
        parse_full_args
        sanitize_members
        return_message
      end

      private

      def parse_full_args
        index = (full_args.index('-t') || full_args.index('--team')) + 1
        message_index = full_args.index('-m') || full_args.index('--message')

        self.members_list = if !message_index || (message_index && (index > message_index))
          full_args[index..-1]
        else
          full_args[index...message_index]
        end
      end

      def sanitize_members
        self.members_list.map! {|m| m.chomp(',').strip}

        if !self.members_list.all? {|m| m.start_with?('@')}
          self.members_list.each {|m| m.prepend('@') if !m.start_with?('@')}
        end
      end

      def return_message
        "team: #{self.members_list.join(' ')}"
      end
    end
  end
end
