require 'rails_helper'

describe WalksController, type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  before { sign_in user }
  
  describe '#new' do
    scenario 'new page returns 200 status' do
      visit new_walk_path

      expect(page.status_code).to eq 200
      expect(page.current_path).to eq new_walk_path
    end
  end

  describe '#create' do
    scenario 'new walk is submited' do
      visit new_walk_path

      fill_in 'Start point', with: 'Plac Europejski 2, Warszawa, Polska'
      fill_in 'End point', with: 'Poznańska 121, Warszawa, Polska'

      click_button 'Submit'

      expect(page).to have_content('On your last walk you made distance of 1.99 km')
    end

    scenario 'invalid data is submited' do
      visit new_walk_path

      fill_in 'Start point', with: 'No city 2, Polska'
      fill_in 'End point', with: 'No street number, Warszawa, Polska'

      click_button 'Submit'

      expect(page).to have_content('Start location is invalid')
      expect(page).to have_content('End location is invalid')
    end
  end
end
