require "uuid"

module Slate
  module Identity
    enum UserRole
      Standard
      SystemOwner
    end

    struct User
      getter id : UUID
      getter display_name : String
      getter role : UserRole

      def initialize(@id : UUID, @display_name : String, @role : UserRole)
        unless @id.v7?
          raise ArgumentError.new("User ids must be UUIDv7.")
        end
      end

      def system_owner? : Bool
        role.system_owner?
      end
    end
  end
end
