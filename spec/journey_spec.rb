require 'journey'

describe Journey do
    subject {described_class.new}

    let(:entry_station) { double :station }
    let(:exit_station)  { double :station }

    before do
        allow(entry_station).to receive(:name).and_return("Bank")
        allow(entry_station).to receive(:zone).and_return(1)
        allow(exit_station).to receive(:name).and_return("Poplar")
        allow(exit_station).to receive(:zone).and_return(2)
    end

    describe '#start_journey' do
        it 'sets an entry_station' do
            subject.start_journey(entry_station)
            expect(subject.trip[:entry_station]).to eq entry_station
        end
    end

    describe '#finish_journey' do
        it 'sets an exit_station' do
            subject.finish_journey(exit_station)
            expect(subject.trip[:exit_station]).to eq exit_station
        end
    end

    describe '#complete_journey' do
      context  'check for complete journey' do
        before do
          subject.start_journey(:entry_station)
          subject.finish_journey(:exit_station)
      end
      it 'returns true for complete journey' do
        expect(subject.complete_journey).to eq true
      end
    end
       context 'tap out without tapping in' do
         before do
           subject.finish_journey(:exit_station)
         end
         it 'return incompleted journey false' do
             expect(subject.complete_journey).to eq false
         end
       end
    end
    
    describe '#fare' do
        context 'complete journey returns min fare' do
            before do
                subject.start_journey(:entry_station)
                subject.finish_journey(:exit_station)
            end
            
            it 'returns minimum_fare' do
                expect(subject.fare).to eq (Journey::MINIMUM_FARE)
            end
        end
        
        context 'incomplete journey returns penalty fare' do
            before do
                subject.finish_journey(:exit_station)
            end
            
            it 'returns penalty fare' do
                expect(subject.fare).to eq (Journey::PENALTY_FARE)
            end
        end
    end
end
