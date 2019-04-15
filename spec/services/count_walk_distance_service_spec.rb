require 'rails_helper'

describe CountWalkDistanceService, :vcr, type: :service do
  describe '#call' do
    let(:walk) { build(:walk) }
    subject { described_class.new(walk) }

    it 'counts distance' do
      expect(walk.distance).to eq(0.0)
      subject.call
      expect(walk.distance).to eq(2.36)
    end
  end
end
