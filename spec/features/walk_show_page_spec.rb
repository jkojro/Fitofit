require 'rails_helper'

describe WalksController, type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  before { sign_in user }

  describe '#show' do
    scenario 'display last walk distance' do
      walk = FactoryBot.create(:walk)

      visit walk_path(walk.id)

      expect(page.status_code).to eq 200
      expect(page.current_path).to eq walk_path(walk.id)
      expect(page).to have_content('On your last walk you made distance of 1.99 km')
    end

    scenario 'display users this week summary distance' do
      this_week_walks = FactoryBot.create_list(:walk, 3, user_id: user.id)
      last_week_walks = FactoryBot.create_list(:walk, 2, created_at: 1.week.ago, user_id: user.id)
      other_users_walks = FactoryBot.create_list(:walk, 2)

      visit walk_path(this_week_walks.last.id)

      expect(page).to have_content('Your summary distance in this week is 5.97 km')
    end
  end
end
