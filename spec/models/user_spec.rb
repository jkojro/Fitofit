require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relations' do
    it { should have_many(:walks) }
  end

  describe 'validations' do
    context 'presence' do
      subject { FactoryBot.build(:user) }
      it { should validate_presence_of(:email) }
    end

    context 'uniqueness' do
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end
end
