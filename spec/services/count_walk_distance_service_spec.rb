require 'rails_helper'

describe AssignWalkDistanceService, :vcr, type: :service do
  describe '#call' do
    describe 'valid locations' do
      let(:walk) { build(:walk, distance: 0.0) }
      subject { described_class.new.call(walk: walk) }

      it 'counts distance' do
        expect(walk.distance).to eq(0.0)
        expect(subject).to be_success
        expect(walk.distance).to eq(2.36)
      end
    end

    describe 'invalid locations' do
      let(:walk) { build(:walk, distance: 0.0, start_location: 'invalid location') }
      subject { described_class.new.call(walk: walk) }

      it 'counts distance' do
        expect(subject).to be_failure
      end
    end
  end
end
