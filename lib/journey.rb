class Journey
    attr_reader :trip
    
    MINIMUM_FARE = 1
    PENALTY_FARE = 6
    
    def initialize
        @trip = {}
    end

    def start_journey(entry_station)
        trip[:entry_station] = entry_station
    end

    def finish_journey(exit_station)
        trip[:exit_station] = exit_station
    end

    def complete_journey
       trip.size == 2
    end
    
    def fare
        complete_journey ? MINIMUM_FARE : PENALTY_FARE
    end
end
