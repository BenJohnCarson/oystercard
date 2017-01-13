require 'oystercard'
require 'journey'

describe 'User Stories' do
    subject(:card)          { Oystercard.new }
    subject(:journey)       { Journey.new }
    subject(:station)       { Station.new(name: "Bank", zone: 1) }
    
    let(:entry_station)     { double :station }
    let(:exit_station)      { double :station }
    
    describe 'User story 1' do
        # In order to use public transport
        # As a customer
        # I want money on my card
        it 'can store a balance' do
            expect(card.balance).to eq 0
        end
    end
    
    describe 'User story 2' do
        # In order to keep using public transport
        # As a customer
        # I want to add money to my card
        it 'can top up' do
            expect{ card.top_up(10) }.to change{ card.balance }.by 10
        end
    end
    
    describe 'User story 3' do
        # In order to protect my money
        # As a customer
        # I don't want to put too much money on my card
        it 'has a max balance' do
            limit = Oystercard::BALANCE_LIMIT
            expect{ card.top_up(limit + 1)}.to raise_error(BalanceError, "Maximum balance of #{limit} exceeded")
        end
    end
    
    describe 'User story 6' do
        # In order to pay for my journey
        # As a customer
        # I need to have the minimum amount for a single journey
        it 'can\'t touch in without sufficient balance' do
            expect{card.touch_in(entry_station)}.to raise_error "Insufficient funds"
        end
    end
    
    context 'card has full balance and has touched in' do
        before do 
            card.top_up(Oystercard::BALANCE_LIMIT)
            card.touch_in(entry_station)
        end
        
        describe 'User story 4 + 5 + 7' do
            # In order to pay for my journey
            # As a customer
            # I need my fare deducted from my card
            
            # In order to get through the barriers
            # As a customer
            # I need to touch in and out
            
            # In order to pay for my journey
            # As a customer
            # I need to pay for my journey when it's complete
            it 'deducts a fare from balance' do
                expect{ card.touch_out(exit_station) }.to change{ card.balance }.by(-Journey::MINIMUM_CHARGE)
            end
        end
        
        describe 'User story 9' do
            # In order to know where I have been
            # As a customer
            # I want to see to all my previous trips
            it 'stores journeys' do
                journey.start(entry_station)
                journey.finish(exit_station)
                trip = journey.trip
                card.touch_out(exit_station)
                expect(card.journey_log).to include trip
            end
        end
        
        describe 'User story 11' do
            # In order to be charged correctly
            # As a customer
            # I need a penalty charge deducted if I fail to touch in or out
            it 'deducts penalty when failing to touch out' do
                expect{ card.touch_in(entry_station) }.to change{ card.balance }.by(-Journey::PENALTY)
            end
            
            it 'deducts penalty when failing to touch_in' do
                card.touch_out(exit_station)
                expect{ card.touch_out(exit_station) }.to change{ card.balance }.by(-Journey::PENALTY)
            end
        end
    end
    
    describe 'User story 8' do
        # In order to pay for my journey
        # As a customer
        # I need to know where I've travelled from
        it 'stores entry station' do
            journey.start(entry_station)
            expect(journey.trip[:entry_station]).to eq entry_station
        end
    end
    
    describe 'User story 10' do
        # In order to know how far I have travelled
        # As a customer
        # I want to know what zone a station is in
        it 'a station knows it\'s zone' do
            expect(station.zone).to eq 1
        end
    end
end