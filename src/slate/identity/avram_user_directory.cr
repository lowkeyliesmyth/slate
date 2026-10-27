require "./user_directory"

module Slate
  module Identity
    # Avram adapter that translates persisted DirectoryUser records into the  domain User model.
    class AvramUserDirectory < UserDirectory
      # Initialization construction stores the lookup without actually executing it or opening a connection.
      def initialize(
        # Instantiates a class var that is assigned as a proc that takes an id and returns the first matching DirectoryUser result.
        @lookup : Proc(UUID, ::DirectoryUser?) = ->(id : UUID) { ::DirectoryUserQuery.new.id(id).first? },
      )
      end

      # Look up a synthetic DirectoryUser by **id** via the configured lookup proc and map it to a domain User.
      #
      # Return nil if no user is found.
      def find(id : UUID) : User?
        return nil unless record = @lookup.call(id)

        User.new(record.id, record.display_name, record.role)
      end
    end
  end
end
