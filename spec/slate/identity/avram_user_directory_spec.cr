require "spec"
require "avram"
require "../../../src/app_database"
require "../../../src/models/base_model"
require "../../../src/models/directory_user"
require "../../../src/queries/directory_user_query"
require "../../../src/slate/identity/avram_user_directory"

# Storage double that records requested identifiers without accessing PG.
# Returns a configured record, a missing result, or a simulated storage failure.
private class DirectoryRecordLookupDouble
  getter requested_ids = [] of UUID

  # Accepts a record id to lookup and if a simulated failure is enabled or not.
  def initialize(@record : DirectoryUser? = nil, @fail : Bool = false)
  end

  # Take the **id** and return the associated DirectoryUser if it exists.
  # Raises a RuntimeError if a simulated storage failure is enabled.
  def find(id : UUID) : DirectoryUser?
    @requested_ids << id
    raise RuntimeError.new("Directory storage unavailable") if @fail
    @record
  end
end

describe Slate::Identity::AvramUserDirectory do
  it "queries an id and maps the persisted record" do
    id = UUID.new("00000000-0000-7000-8000-000000000001")
    now = Time.utc
    record = DirectoryUser.new(
      id: id,
      created_at: now,
      updated_at: now,
      display_name: "Stored Name",
      role: Slate::Identity::UserRole::SystemOwner.value
    )
    storage = DirectoryRecordLookupDouble.new(record)
    directory = Slate::Identity::AvramUserDirectory.new(
      ->(requested_id : UUID) { storage.find(requested_id) }
    )

    user = directory.find(id).not_nil!

    storage.requested_ids.should eq([id])
    user.id.should eq(id)
    user.display_name.should eq("Stored Name")
    user.system_owner?.should be_true
  end

  it "returns nil when the persisted user is missing" do
    storage = DirectoryRecordLookupDouble.new
    directory = Slate::Identity::AvramUserDirectory.new(
      ->(id : UUID) { storage.find(id) }
    )
    id = UUID.new("00000000-0000-7000-8000-000000000002")
    directory.find(id).should be_nil
    storage.requested_ids.should eq([id])
  end

  it "propagates storage failures" do
    storage = DirectoryRecordLookupDouble.new(fail: true)
    directory = Slate::Identity::AvramUserDirectory.new(
      ->(id : UUID) { storage.find(id) }
    )

    expect_raises(RuntimeError, "Directory storage unavailable") do
      directory.find(UUID.new("00000000-0000-7000-8000-000000000009"))
    end
  end
end
