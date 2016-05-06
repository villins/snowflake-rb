require 'test_helper'

class Snowflake::RbTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Snowflake::Rb::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
