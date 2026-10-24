# Create development directory_users.
class CreateDirectoryUsers::V20261022000000 < Avram::Migrator::Migration::V1
  # Queue up the table creation and hydration. I think the migration runner executes these as transactions?
  def migrate
    create table_for(DirectoryUser) do
      primary_key id : UUID
      add_timestamps
      add display_name : String
      add role : Int32
    end
  end

  # Queue up the actions for an explicit migration rollback.
  def rollback
    drop table_for(DirectoryUser)
  end
end
