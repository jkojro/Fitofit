require 'rails_helper'

describe WalksController, type: :feature do

  describe '#show' do
    walk = FactoryBot.create(:walk)

    scenario 'display last walk distance' do

      visit walk_path(walk.id)

      expect(page.status_code).to eq 200
      expect(page.current_path).to eq walk_path(walk.id)
      expect(page).to have_content('On your last walk you made distance of 1.99 km')
    end

    scenario 'display this week summary distance' do
      last_week_walks = FactoryBot.create_list(:walk, 2, created_at: 1.week.ago)

      visit walk_path(walk.id)

      expect(page).to have_content('Your summary distance in this week is 1.99 km')
    end
  end
end
