require "./user"

module Slate
  module Identity
    module Fixtures
      TIDUS = User.new(
        UUID.new("deadbeef-cc00-7000-8000-000000000001"),
        "Tidus",
        UserRole::Standard
      )

      YUNA = User.new(
        UUID.new("deadbeef-cc00-7000-8000-000000000002"),
        "Yuna",
        UserRole::Standard
      )

      AURON = User.new(
        UUID.new("deadbeef-cc00-7000-8000-000000000003"),
        "Auron",
        UserRole::SystemOwner
      )

      ALL = {TIDUS, YUNA, AURON}
    end
  end
end
