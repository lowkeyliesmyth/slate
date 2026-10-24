require "uuid"

module Slate
  module Identity
    enum UserRole
      # Making these implicit values explicit to more easily tie them to the directoryuser PG table role values.
      Standard    = 0
      SystemOwner = 1
    end

    struct User
      getter id : UUID
      getter display_name : String
      getter role : UserRole

      def initialize(@id : UUID, @display_name : String, @role : UserRole)
      end

      def system_owner? : Bool
        role.system_owner?
      end
    end
  end
end
