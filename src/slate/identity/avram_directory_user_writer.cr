require "./directory_user_writer"
require "../../models/directory_user"
require "../../queries/directory_user_query"
require "../../operations/save_directory_user"

module Slate
  module Identity
    # Add missing directory records through Avram without overwriting any existing records.
    # Usage:
    #   `AvramDirectoryUserWriter.new.ensure_user(user)`
    class AvramDirectoryUserWriter < DirectoryUserWriter
      # Accepts `exists` and `insert` procs at construction. Defaults use postgres as the storage layer but can be overridden in unit tests.
      #
      # No database calls are invoked at construction time.
      def initialize(
        @exists : Proc(UUID, Bool) = ->(id : UUID) {
          ::DirectoryUserQuery.new.id(id).any?
        },
        @insert : Proc(User, Nil) = ->(user : User) {
          ::SaveDirectoryUser.create!(
            id: user.id,
            display_name: user.display_name,
            role: user.role
          )
          nil
        },
      )
      end

      # Insert **user** with its provided `id` if missing from the storage backend.
      # Existing records are not modified.
      def ensure_user(user : User) : Nil
        return if @exists.call(user.id)

        @insert.call(user)
      end
    end
  end
end
