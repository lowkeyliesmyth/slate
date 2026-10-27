require "spec"
require "../../../src/slate/identity/development_user_seeder"

# Record seeding requests without accessing external storage.
private class DevelopmentSeedWriterDouble < Slate::Identity::DirectoryUserWriter
  getter calls = [] of Slate::Identity::User

  # Setting **fail** simulates inaccessible storage.
  def initialize(@fail : Bool = false)
  end

  # Record **user**, or raise if fail is enabled.
  def ensure_user(user : Slate::Identity::User) : Nil
    raise RuntimeError.new("Directory write unavailable") if @fail
    @calls << user
    nil
  end
end

describe Slate::Identity::DevelopmentUserSeeder do
  it "passes the fixed identities to storage when access is enabled" do
    writer = DevelopmentSeedWriterDouble.new

    Slate::Identity::DevelopmentUserSeeder.new(writer, true).seed

    writer.calls.map(&.id).should eq(
      Slate::Identity::Fixtures::ALL.map(&.id).to_a
    )
  end

  it "doesn't touch storage when fail is turned on" do
    writer = DevelopmentSeedWriterDouble.new(fail: true)

    Slate::Identity::DevelopmentUserSeeder.new(writer, false).seed

    writer.calls.should be_empty
  end

  it "propagates storage failures" do
    # turn on failure
    writer = DevelopmentSeedWriterDouble.new(fail: true)
    # turn on development_mode to fully activate the code path
    seeder = Slate::Identity::DevelopmentUserSeeder.new(writer, true)

    expect_raises(RuntimeError, "Directory write unavailable") do
      seeder.seed
    end
  end

  it "reuses the same identifiers on repeat setup" do
    writer = DevelopmentSeedWriterDouble.new
    seeder = Slate::Identity::DevelopmentUserSeeder.new(writer, true)

    seeder.seed
    orig_ids = writer.calls.map(&.id)
    seeder.seed

    writer.calls.map(&.id).should eq(orig_ids + orig_ids)
  end
end
