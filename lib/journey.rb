class Journey
    
    MINIMUM_CHARGE = 1
    PENALTY = 6
    
    attr_reader :trip
    
    def initialize
        @trip = {}
    end
    
    def start(station)
        @trip[:entry_station] = station
    end
    
    def finish(station)
        @trip[:exit_station] = station
    end
    
    def fare
        journey_complete? ? MINIMUM_CHARGE : PENALTY
    end
    
    private
    
    def journey_complete?
        trip[:entry_station] && trip[:exit_station]
    end
end