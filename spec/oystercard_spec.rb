require 'oystercard'


describe Oystercard do

    let(:entry_station)     { double :station }
    let(:exit_station)      { double :station }
    
    subject(:oystercard)    {described_class.new}
    
    it 'Shows initial balance of zero' do
        expect(oystercard).to have_attributes(:balance => 0)
    end
    
    it "checks if balance is less than minimum limit" do
        expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
    end
    
    it 'has an empty list of journeys by default' do
        expect(oystercard.journey_log).to be_empty
    end
    
    it 'can top up balance' do
        expect{ oystercard.top_up(10) }.to change{ oystercard.balance }.by 10
    end
    
    context 'it has a full balance' do
        before{oystercard.top_up(Oystercard::BALANCE_LIMIT)}
        
        it "won't let you top up over the balance limit" do
             expect{ oystercard.top_up(1)}.to raise_error(BalanceError, "Maximum balance of #{Oystercard::BALANCE_LIMIT} exceeded")
        end
        
        context 'user starts a journey' do
            before{ oystercard.touch_in(entry_station) }
            
            it 'reduces minimum fare from balance when touching out' do
                expect{ oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-Journey::MINIMUM_CHARGE)
            end
            
            let(:trip){ {entry_station: entry_station, exit_station: exit_station} }
            
            it 'stores a journey' do
                oystercard.touch_out(exit_station)
                expect(oystercard.journey_log).to include trip
            end
        end
    end
end
