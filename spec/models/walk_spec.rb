require 'rails_helper'

RSpec.describe Walk, type: :model do
  describe 'validations' do
    context 'presence' do
      subject { FactoryBot.build(:walk) }
      it { should validate_presence_of(:start_location) }
      it { should validate_presence_of(:end_location) }
    end

    context "location format" do
      it { should allow_value("Plac Europejski 2, Warszawa, Polska").for(:start_location) }
      it { should allow_value("Puławska Ęłźżcz polskie znaki 2, Warszawa, Polska").for(:end_location) }
      it { should_not allow_value("Plac Europejski, Warszawa, Polska").for(:start_location) }
      it { should_not allow_value("Plac Europejski 3, Warszawa").for(:end_location) }
    end

    context "start different than end" do
      subject { FactoryBot.build(:walk, start_location: "Plac Europejski 2, Warszawa, Polska", end_location: "Plac Europejski 2, Warszawa, Polska") }
      it 'validates for difference between start and end' do
        subject.should_not be_valid
      end
    end
  end

  describe 'distance count' do
    subject { FactoryBot.build(:walk) }
    it 'counts distance' do
      subject.save
      expect(subject.distance).to eq(1.99)
    end
  end
end
