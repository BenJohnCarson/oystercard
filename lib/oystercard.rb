require_relative 'balance_error'
require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class Oystercard
    
    BALANCE_LIMIT = 90
    
    attr_reader :balance, :journey_log, :journey_log_class
    
    def initialize(journey = Journey.new, journey_log_class = Journey_log.new(journey_class: Journey.new))
        @balance = 0
        @journey_log = []
        @journey_log_class = journey_log_class
        @journey = journey
    end
    
    def top_up(amount)
        fail(BalanceError, "Maximum balance of #{BALANCE_LIMIT} exceeded") if over_limit?(amount)
        @balance += amount
    end
    
    def touch_in(station)
        fail "Insufficient funds" if balance < Journey::MINIMUM_CHARGE
        deduct(journey.fare) if already_touched_in?
        journey.start(station)
        nil
    end
    
    def touch_out(station)
        journey.finish(station)
        deduct(journey.fare)
        journey_log << journey.trip
        @journey = Journey.new
        nil
    end
    
    private
    
    attr_reader :journey
    
    def already_touched_in?
        !!journey.trip[:entry_station]
    end
    
    def deduct(amount)
        @balance -= amount
    end
    
    def over_limit?(amount)
        (@balance + amount) > BALANCE_LIMIT
    end
end
