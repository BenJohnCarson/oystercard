require 'journey'

describe Journey do
    
    let(:entry_station) { double :station }
    let(:exit_station)  { double :station }
    
    subject(:journey)   {described_class.new}
    
    it 'has a penalty fare' do
        expect(journey.fare).to eq Journey::PENALTY
    end
    
    context 'passed an entry station' do
        before{ journey.start(entry_station) }
    
        it 'saves an entry station' do
            expect(journey.trip[:entry_station]).to eq entry_station
        end
    end
        
    context 'passed an exit station' do
        before{ journey.finish(exit_station) }
        
        it 'saves an exit station' do
            expect(journey.trip[:exit_station]).to eq exit_station
        end
        
        it 'deducts penalty if no entry station in trip' do
            expect(journey.fare).to eq Journey::PENALTY
        end
    end
end