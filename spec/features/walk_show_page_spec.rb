require 'rails_helper'

describe WalksController, type: :feature do

  describe '#show' do
    scenario 'display last walk distance' do
      walk = FactoryBot.create(:walk)

      visit walk_path(walk.id)

      expect(page.status_code).to eq 200
      expect(page.current_path).to eq walk_path(walk.id)
      expect(page).to have_content('On your last walk you made distance of 1.99 km')
    end

    scenario 'display this week summary distance' do
      this_week_walks = FactoryBot.create_list(:walk, 3)
      last_week_walks = FactoryBot.create_list(:walk, 2, created_at: 1.week.ago)

      visit walk_path(this_week_walks.last.id)

      expect(page).to have_content('Your summary distance in this week is 5.97 km')
    end
  end
end
