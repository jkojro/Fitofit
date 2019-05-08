require 'rails_helper'

describe  PresentWeekWalksDistance, :vcr do
  describe '#call' do
    subject(:present_week_walks_distance) { described_class.new }

    let(:user) { create(:user) }
    let!(:last_week_walks) { create(:walk, created_at: 1.week.ago, user_id: user.id) }
    let!(:this_week_walks) { create_list(:walk, 2, user_id: user.id) }
    let!(:other_user_walks) { create(:walk) }

    it 'returns total distance from users this week walks' do
      expect(present_week_walks_distance.call(user)).to eq(4.72)
    end
  end
end
