require 'snowflake-rb/snowflake'

module Snowflake
  module Rb
    def self.snowflake(worker_id, region_id)
      Snowflake.new(worker_id, region_id)
    end
  end
end
