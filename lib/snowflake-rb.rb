require 'snowflake-rb/snowflake'
module Snowflake
  module Rb
    def self.snowflake(wokder_id, region_id)
      Snowflake.new(wokder_id, region_id)
    end
  end
end
