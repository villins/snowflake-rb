require 'monitor'

module SnowflakeRb
  class Snowflake
    attr_accessor :worker_id, :region_id, :lock, :last_timestamp, :sequence

    class WorkerIdOutRangeError < StandardError; end
    class RegionIdOutRangeError < StandardError; end
    class TimeMoveBackWardError < StandardError; end

    # 基准时间
    TWEPOCH = 1462525962386
    # 区域标志位数
    REGION_ID_BITS = 3
    # 机器标识位数
    WORKER_ID_BITS = 10
    # 序列号识位数
    SEQUENCE_BITS = 10
    # 区域id最大值
    MAX_REGION_ID = -1 ^ (-1 << REGION_ID_BITS)
    # 机器id最大值
    MAX_WORKDER_ID = -1 ^ (-1 << WORKER_ID_BITS)
    #序列号ID最大值
    SEQUENCE_MASK = -1 ^ (-1 << SEQUENCE_BITS)
    # 机器id偏左移10位
    WORKDER_ID_LEFT_SHIFT = SEQUENCE_BITS
    # 业务ID偏左移20位
    REGION_ID_LEFT_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS
    # 时间毫秒左移23位
    TIMESTAMP_LEFT_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS + REGION_ID_BITS

    def initialize(worker_id, region_id)
      @worker_id = worker_id
      @region_id = region_id
      @lock = Monitor.new
      @last_timestamp = 0
      @sequence = 0
      valid_range
    end

    def next_id
      lock.synchronize do
        timestamp = get_timestamp

        if timestamp < last_timestamp
          diff_milliseconds = last_timestamp - timestamp
          raise TimeMoveBackWardError.new("Refusing to generate id for #{ diff_milliseconds } milliseconds")
        end

        if timestamp == last_timestamp
          @sequence = (sequence + 1) & SEQUENCE_MASK

          if sequence == 0
            timestamp = tail_next_timestamp(last_timestamp)
          end
        else
          @sequence = rand(10)
        end

        @last_timestamp = timestamp

        return ((timestamp - TWEPOCH) << TIMESTAMP_LEFT_SHIFT) | (region_id << REGION_ID_LEFT_SHIFT) | (worker_id << WORKDER_ID_LEFT_SHIFT) | sequence
      end
    end

    def tail_next_timestamp(last_timestamp)
      timestamp = get_timestamp

      while (timestamp <= last_timestamp)
        timestamp = get_timestamp
      end

      return timestamp
    end

    def get_timestamp
      (Time.now.to_f * 1000).to_i 
    end

    def valid_range
      if worker_id < 0 || worker_id > MAX_WORKDER_ID
        raise WorkerIdOutRangeError.new
      end

      if region_id < 0 || region_id > MAX_REGION_ID
        raise RegionIdOutRangeError.new
      end
    end
  end
end
