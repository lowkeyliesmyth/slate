require "./user"

module Slate
  module Identity
    abstract class UserDirectory
      # Return the current directory-user for **id**, or nil when absent.
      # Storage failures must propagate and not be treated as missing users.
      abstract def find(id : UUID) : User?
    end
  end
end
