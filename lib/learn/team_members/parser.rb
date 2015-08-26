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
        index = (full_args.index('-t') || full_args.index('--t') || full_args.index('--team') || full_args.index('-team')) + 1
        message_index = full_args.index('-m') || full_args.index('--message')

        self.members_list = if !message_index || (message_index && (index > message_index))
          full_args[index..-1]
        else
          full_args[index...message_index]
        end
      end

      def sanitize_members
        remove_trailing_commas!

        if members_list.any? {|m| m.include?(',')}
          split_members_list!
        end

        if !every_member_starts_with_at_symbol?
          prepend_at_symbols!
        end
      end

      def split_members_list!
        members_list.map! do |m|
          if m.include?(',')
            m.split(',')
          else
            m
          end
        end

        members_list.flatten!
      end

      def remove_trailing_commas!
        members_list.map! {|m| m.chomp(',').strip}
      end

      def every_member_starts_with_at_symbol?
        members_list.all? {|m| m.start_with?('@')}
      end

      def prepend_at_symbols!
        members_list.each {|m| m.prepend('@') if !m.start_with?('@')}
      end

      def return_message
        "team: #{self.members_list.join(' ')}"
      end
    end
  end
end
