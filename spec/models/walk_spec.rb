require 'rails_helper'

RSpec.describe Walk, type: :model do
  describe 'validations' do
    context 'presence' do
      subject { FactoryBot.build(:walk) }
      it { should validate_presence_of(:start_location) }
      it { should validate_presence_of(:end_location) }
      it { should validate_presence_of(:distance) }
    end

    context "location format" do
      it { should allow_value("Plac Europejski 2, Warszawa, Polska").for(:start_location) }
      it { should allow_value("Puławska Ęłźżcz polskie znaki 2, Warszawa, Polska").for(:end_location) }
      it { should_not allow_value("Plac Europejski, Warszawa, Polska").for(:start_location) }
      it { should_not allow_value("Plac Europejski 3, Warszawa").for(:end_location) }
    end
  end
end
