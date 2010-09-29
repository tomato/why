class LastOrdersDuration
  attr_reader :days, :hour_of_day

  def initialize(days, hour_of_day)
    @days = days
    @hour_of_day = hour_of_day
  end

  def self.from_seconds(seconds)
    remaining_seconds = seconds % 1.day.to_i
    seconds_of_day = (remaining_seconds > 0) ? 1.day.to_i - remaining_seconds : 0 
    hour_of_day = seconds_of_day / 1.hour.to_i
    days = (seconds + seconds_of_day) / 1.day.to_i
    self.new(days, hour_of_day)
  end

  def to_i
    -(-days.day.to_i + hour_of_day.hour.to_i)
  end
end
