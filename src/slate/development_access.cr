module Slate
  module DevelopmentAccess
    class ConfigurationError < Exception
    end

    # Resolve provided configuration for whether synthetic identity development access is allowed or not.
    #
    # Convert the resolved **config_entry** for this **environment** into an authoritative _enabled_ Bool.
    def self.resolve(config_entry : String?, environment : String) : Bool
      enabled = case config_entry
                when nil, "false"
                  false
                when "true"
                  true
                else
                  raise ConfigurationError.new(
                    "SLATE_DEVELOPMENT_ACCESS can only be true, false, or omitted."
                  )
                end
      if enabled && environment != "development"
        raise ConfigurationError.new(
          "SLATE_DEVELOPMENT_ACCESS=true is only safe and allowed in LUCKY_ENV=development."
        )
      end
      enabled
    end
  end
end
