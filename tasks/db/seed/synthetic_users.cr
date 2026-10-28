require "../../../src/slate/identity/avram_directory_user_writer"
require "../../../src/slate/identity/development_user_seeder"

# Runs explicit synthetic record setup through the guarded development-only seeder as a task called from lucky CLI.
#
# Usage: lucky db.seed.synthetic_users
class Db::Seed::SyntheticUsers < LuckyTask::Task
  summary "Set up explicitly enabled synthetic directory identities"

  # Standard execution method called by `lucky` CLI for out of band tasks.
  # Returns Nil on completion.
  def call : Nil
    writer = Slate::Identity::AvramDirectoryUserWriter.new

    Slate::Identity::DevelopmentUserSeeder.new(
      writer,
      Application.settings.development_access
    ).seed

    puts "Synthetic identities are only seeded in dev environment with SLATE_DEVELOPMENT_ACCESS=true."
  end
end
