require "spec"
require "../../src/slate/development_access"

describe Slate::DevelopmentAccess do
  it "allows synthetic access when explicitly enabled in development" do
    Slate::DevelopmentAccess.resolve("true", "development").should be_true
  end

  ["development", "test", "production", "staging"].each do |env|
    it "disables synthetic access when config is missing in #{env}" do
      Slate::DevelopmentAccess.resolve(nil, env).should be_false
    end

    it "disables synthetic access when set to false in #{env}" do
      Slate::DevelopmentAccess.resolve("false", env).should be_false
    end
  end

  ["test", "production", "staging"].each do |env|
    it "rejects enabled synthetic access in #{env}" do
      expect_raises(Slate::DevelopmentAccess::ConfigurationError) do
        Slate::DevelopmentAccess.resolve("true", env)
      end
    end
  end

  it "rejects invalid config entries" do
    ["", "TRUE", "1", "yes", " true"].each do |cfg|
      expect_raises(Slate::DevelopmentAccess::ConfigurationError) do
        Slate::DevelopmentAccess.resolve(cfg, "development")
      end
    end
  end
end
