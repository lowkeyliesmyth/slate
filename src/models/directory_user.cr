require "../slate/identity/user"

# Persisted directory_user identity records, for inner-loop local development and testing only. These are distinctly different from Authentic login accounts.
class DirectoryUser < BaseModel
  skip_default_columns

  table do
    primary_key id : UUID
    timestamps
    column display_name : String
    column role : Slate::Identity::UserRole
  end
end
