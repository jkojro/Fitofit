require 'rails_helper'

describe PresentMonthWalksQuery, :vcr do
  describe '#call' do
    subject(:present_month_walks) { described_class.new }

    let(:user) { create(:user) }
    let!(:last_month_walks) { create(:walk, created_at: 1.month.ago, user_id: user.id) }
    let!(:this_month_walks) { create(:walk, user_id: user.id) }
    let!(:other_user_walks) { create(:walk) }

    it 'returns all this month walks' do
      expect(present_month_walks.call(Walk.all).values.first).to eq(4.72)
    end

    it 'returns users this month walks' do
      expect(present_month_walks.call(user.walks).values.first).to eq(2.36)
    end
  end
end
