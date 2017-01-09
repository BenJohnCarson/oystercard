class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1

    attr_reader :balance

    def initialize
        @in_use = false
        @balance = 0
    end

    def top_up(amount)
        raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def deduct(amount)
      @balance -= amount
    end

    def in_journey?
        in_use
    end

    def touch_in
      raise 'Sorry your balance is too low' if balance < MINIMUM_BALANCE
        @in_use = true
    end

    def touch_out
        @in_use = false
    end

    private

    attr_reader :in_use
end
