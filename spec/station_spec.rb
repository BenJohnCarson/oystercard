require 'station'

describe Station do
    
    name = "Bank"
    zone = 1
    subject {described_class.new(name: name, zone: zone)}
    
    it 'saves its name' do
        expect(subject.name).to eq name
    end
    
    it 'saves a zone' do
        expect(subject.zone).to eq zone
    end
end