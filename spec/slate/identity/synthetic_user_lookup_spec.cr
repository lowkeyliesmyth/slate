require "spec"
require "../../../src/slate/identity/synthetic_user_lookup"

private class SyntheticLookupDirectoryDouble < Slate::Identity::UserDirectory
  getter calls : Int32 = 0

  def initialize(@user : Slate::Identity::User? = nil, @fail : Bool = false)
  end

  def find(id : UUID) : Slate::Identity::User?
    @calls += 1
    raise RuntimeError.new("Directory unavailable") if @fail

    if user = @user
      return user if user.id == id
    end

    nil
  end
end

describe Slate::Identity::SyntheticUserLookup do
  it "returns the current directory record rather than the fixture record" do
    stored_user = Slate::Identity::User.new(
      Slate::Identity::Fixtures::TIDUS.id,
      "Updated directory name",
      Slate::Identity::UserRole::Standard
    )
    directory = SyntheticLookupDirectoryDouble.new(stored_user)
    lookup = Slate::Identity::SyntheticUserLookup.new(directory, true)

    result = lookup.resolve(stored_user.id)

    result.id.should eq(stored_user.id)
    result.display_name.should eq("Updated directory name")
    directory.calls.should eq(1)
  end

  it "rejects disabled access upfront" do
    directory = SyntheticLookupDirectoryDouble.new
    lookup = Slate::Identity::SyntheticUserLookup.new(directory, false)

    expect_raises(Slate::Identity::SyntheticUserLookup::AccessDenied) do
      lookup.resolve(Slate::Identity::Fixtures::TIDUS.id)
    end
  end

  it "rejects users outside the synthetic set without checking storage" do
    directory = SyntheticLookupDirectoryDouble.new
    lookup = Slate::Identity::SyntheticUserLookup.new(directory, true)
    other_id = UUID.new("00000000-0000-7000-8000-000000000099")

    expect_raises(Slate::Identity::SyntheticUserLookup::UserNotFound) do
      lookup.resolve(other_id)
    end

    directory.calls.should eq(0)
  end

  it "doesn't fallback to fixtures on missing directory records" do
    directory = SyntheticLookupDirectoryDouble.new
    lookup = Slate::Identity::SyntheticUserLookup.new(directory, true)

    expect_raises(Slate::Identity::SyntheticUserLookup::UserNotFound) do
      lookup.resolve(Slate::Identity::Fixtures::TIDUS.id)
    end

    directory.calls.should eq(1)
  end

  it "propagates storage failures" do
    directory = SyntheticLookupDirectoryDouble.new(fail: true)
    lookup = Slate::Identity::SyntheticUserLookup.new(directory, true)

    expect_raises(RuntimeError, "Directory unavailable") do
      lookup.resolve(Slate::Identity::Fixtures::TIDUS.id)
    end
  end
end
