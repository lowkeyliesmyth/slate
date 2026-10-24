require "spec"
require "../../../src/slate/identity/fixtures"

describe Slate::Identity::User do
  it "represents a standard user" do
    user = Slate::Identity::Fixtures::TIDUS

    user.display_name.should eq("Tidus")
    user.role.standard?.should be_true
    user.system_owner?.should be_false
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
end
