class Journey_log
    
    attr_reader :journey_class, :journeys
    
    def initialize(journey_class:)
        @journey_class = journey_class
        @journeys = []
    end
    
    def start(station)
        journey_class.new(entry_station: station)
    end
end