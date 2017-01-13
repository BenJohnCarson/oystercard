require 'journey_log'

describe Journey_log do
    
    let(:entry_station)     { double :station }
    let(:exit_station)      { double :station }
    
    let(:journey)           { double :journey }
    let(:journey_class)     { double :journey_class, new: journey }
    
    subject(:journey_log)   {described_class.new(journey_class: journey_class)}
    
    it 'has an empty list of journeys by default' do
        expect(journey_log.journeys).to be_empty
    end
    
    describe '#start' do
        it 'starts a journey' do
            expect(journey_class).to receive(:new).with(entry_station: entry_station)
            journey_log.start(entry_station)
        end
    end
end