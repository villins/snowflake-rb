require 'bundler/setup'
Bundler.setup

require 'snowflake-rb'

def timestamp 
  Time.now.to_f * 1000
end

sf = Snowflake::Rb.snowflake(1, 1)

n = 0
start = timestamp 
while((timestamp - start) < 1)
  puts sf.next
  n = n + 1
end

puts n
