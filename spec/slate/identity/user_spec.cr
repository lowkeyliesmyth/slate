require "spec"
require "../../../src/slate/identity/fixtures"

describe Slate::Identity::User do
  it "represents a standard user" do
    user = Slate::Identity::Fixtures::TIDUS

    user.display_name.should eq("Tidus")
    user.role.standard?.should be_true
    user.system_owner?.should be_false
    user.id.v7?.should be_true
  end

  it "correctly identifies the system owner role" do
    Slate::Identity::Fixtures::AURON.system_owner?.should be_true
  end

  it "maintains unique identity even with overlapping display names" do
    user = Slate::Identity::User.new(
      Slate::Identity::Fixtures::YUNA.id,
      "Tidus",
      Slate::Identity::UserRole::Standard
    )

    user.display_name.should eq(Slate::Identity::Fixtures::TIDUS.display_name)
    user.id.should_not eq(Slate::Identity::Fixtures::TIDUS.id)
  end

  it "rejects non-v7 uuid" do
    expect_raises(ArgumentError, "User ids must be UUIDv7.") do
      Slate::Identity::User.new(
        UUID.new("00000000-0000-4000-8000-000000000001"),
        "Invalid",
        Slate::Identity::UserRole::Standard
      )
    end
  end
end
