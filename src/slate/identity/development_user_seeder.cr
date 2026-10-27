require "./directory_user_writer"
require "./fixtures"

module Slate
  module Identity
    # Seed fixed synthetic identities when dev access is enabled.
    # Usage: `DevelopmentUserSeeder.new(writer, development_access).seed`
    class DevelopmentUserSeeder
      def initialize(
        @writer : DirectoryUserWriter,
        @development_access : Bool,
      )
      end

      # Ensure each fixed identity exists. Safe to retry after successful writes.
      def seed : Nil
        return unless @development_access

        Fixtures::ALL.each { |user| @writer.ensure_user(user) }
        nil
      end
    end
  end
end
