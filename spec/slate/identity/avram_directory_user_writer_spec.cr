require "spec"
require "avram"
require "../../../src/app_database"
require "../../../src/models/base_model"
require "../../../src/models/directory_user"
require "../../../src/slate/identity/fixtures"
require "../../../src/slate/identity/avram_directory_user_writer"

# Simulates directory storage without actually accessing PG.
# Record existence checks and inserts, with toggle-able storage failures.
private class DirectoryWriteStorageDouble
  getter checked_ids = [] of UUID
  getter users = {} of UUID => Slate::Identity::User
  getter inserted = [] of Slate::Identity::User

  # Accepts `fail_lookup` and `fail_insert` Bool args to toggle simulated failures.
  def initialize(
    @fail_lookup : Bool = false,
    @fail_insert : Bool = false,
  )
  end

  # Check if the provided **id** is stored.
  def exists?(id : UUID) : Bool
    @checked_ids << id
    raise RuntimeError.new("Directory lookup unavailable") if @fail_lookup
    @users.has_key?(id)
  end

  # Insert **user** records into the storage backend.
  def insert(user : Slate::Identity::User) : Nil
    raise RuntimeError.new("Directory insert unavailable") if @fail_insert
    @inserted << user
    @users[user.id] = user
    nil
  end
end

describe Slate::Identity::AvramDirectoryUserWriter do
  it "inserts a missing user with the provided id and attributes" do
    storage = DirectoryWriteStorageDouble.new
    writer = Slate::Identity::AvramDirectoryUserWriter.new(
      ->(id : UUID) { storage.exists?(id) },
      ->(user : Slate::Identity::User) { storage.insert(user) }
    )
    user = Slate::Identity::Fixtures::TIDUS

    writer.ensure_user(user).should be_nil

    storage.checked_ids.should eq([user.id])
    storage.inserted.size.should eq(1)
    stored = storage.users[user.id]
    stored.id.should eq(user.id)
    stored.display_name.should eq(user.display_name)
    stored.role.should eq(user.role)
  end

  it "doesn't insert dupes on retries" do
    storage = DirectoryWriteStorageDouble.new
    writer = Slate::Identity::AvramDirectoryUserWriter.new(
      ->(id : UUID) { storage.exists?(id) },
      ->(user : Slate::Identity::User) { storage.insert(user) }
    )
    user = Slate::Identity::Fixtures::TIDUS

    writer.ensure_user(user)
    writer.ensure_user(user)

    storage.checked_ids.should eq([user.id, user.id])
    storage.inserted.size.should eq(1)
    storage.users.size.should eq(1)
  end

  it "preserves existing record attributes" do
    storage = DirectoryWriteStorageDouble.new
    fixture = Slate::Identity::Fixtures::TIDUS
    existing = Slate::Identity::User.new(
      fixture.id,
      "Existing directory name",
      Slate::Identity::UserRole::SystemOwner
    )
    storage.users[existing.id] = existing
    writer = Slate::Identity::AvramDirectoryUserWriter.new(
      ->(id : UUID) { storage.exists?(id) },
      ->(user : Slate::Identity::User) { storage.insert(user) }
    )

    writer.ensure_user(fixture)

    storage.inserted.should be_empty
    storage.users[fixture.id].display_name.should eq(existing.display_name)
    storage.users[fixture.id].role.should eq(existing.role)
  end

  it "propagates lookup failures without inserting" do
    storage = DirectoryWriteStorageDouble.new(fail_lookup: true)
    writer = Slate::Identity::AvramDirectoryUserWriter.new(
      ->(id : UUID) { storage.exists?(id) },
      ->(user : Slate::Identity::User) { storage.insert(user) }
    )

    expect_raises(RuntimeError, "Directory lookup unavailable") do
      writer.ensure_user(Slate::Identity::Fixtures::TIDUS)
    end

    storage.inserted.should be_empty
  end

  it "propagates insertion failures" do
    storage = DirectoryWriteStorageDouble.new(fail_insert: true)
    writer = Slate::Identity::AvramDirectoryUserWriter.new(
      ->(id : UUID) { storage.exists?(id) },
      ->(user : Slate::Identity::User) { storage.insert(user) }
    )

    expect_raises(RuntimeError, "Directory insert unavailable") do
      writer.ensure_user(Slate::Identity::Fixtures::TIDUS)
    end

    storage.inserted.should be_empty
  end
end
