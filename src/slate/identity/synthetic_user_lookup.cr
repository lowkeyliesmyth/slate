require "./user_directory"
require "./fixtures"

module Slate
  module Identity
    class SyntheticUserLookup
      class AccessDenied < Exception
      end

      class UserNotFound < Exception
      end

      def initialize(@directory : UserDirectory, @development_access : Bool)
      end

      # Resolves **id** to the current directory User.
      # Disabled outside of development.
      # Raises:
      # - AccessDenied when attempted outside of development
      # - UserNotFound for unavailable synthetic user
      # - propagates storage failures
      def resolve(id : UUID) : User
        unless @development_access
          raise AccessDenied.new("Synthetic identity access is disabled.")
        end

        unless Fixtures::ALL.any? { |fixture| fixture.id == id }
          raise UserNotFound.new("Is not a synthetic user.")
        end

        @directory.find(id) || raise UserNotFound.new(
          "Synthetic user is missing from the directory. Run explicit development setup."
        )
      end
    end
  end
end
