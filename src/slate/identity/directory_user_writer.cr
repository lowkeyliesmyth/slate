require "./user"

module Slate
  module Identity
    # Write interface for explicit directory setup.
    # Concrete implementations must preserve existing records and propagate storage failures.
    abstract class DirectoryUserWriter
      # Persists **user** only if it is absent. Existing display names and roles aren't overwritten.
      abstract def ensure_user(user : User) : Nil
    end
  end
end
