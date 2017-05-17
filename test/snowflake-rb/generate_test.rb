require 'test_helper'
require 'pry'
require 'byebug'

class Snowflake::Rb::Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Snowflake::Rb::VERSION
  end

  def test_generate_id_always
    sf = Snowflake::Rb.snowflake(1, 1)
    assert_respond_to(sf, :next, 'should response next method')
    assert_respond_to(sf, :next_id, 'should response next_id method')
  end

  def test_generate_number_type_id
    sf = Snowflake::Rb.snowflake(1, 1)
    100.times do
      assert_instance_of(Bignum, sf.next, 'should generate long number')
    end
  end

  def test_generate_id_different_in_same_time
    Snowflake::Rb::Snowflake.class_eval <<-EOF
      require 'time'
      def get_timestamp
        (Time.parse('2017-01-01').to_f * 10000).to_i
      end
    EOF

    sf = Snowflake::Rb.snowflake(1, 1)

    1000.times do |time|
      if sf.next > 112151276867722151935
        assert false
      end
    end
  end
end
