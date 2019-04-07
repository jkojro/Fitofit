require 'rails_helper'

describe WalksController, type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  before { sign_in user }

  describe '#index' do
    context 'statistics' do
      before do
        FactoryBot.create_list(:walk, 1, created_at: '2019-04-07')
        FactoryBot.create_list(:walk, 2, created_at: '2019-04-07', user_id: user.id)
        FactoryBot.create_list(:walk, 3, created_at: '2019-04-06', user_id: user.id)
        FactoryBot.create_list(:walk, 1, created_at: '2019-04-01', user_id: user.id)
        FactoryBot.create_list(:walk, 1, created_at: '2019-03-31', user_id: user.id)
      end

      scenario 'display actual month name' do
        visit walks_path
        expect(page).to have_content('Your monthly statistics from April')
      end

      scenario 'display actual month statistisc' do
        visit walks_path
        expect(page.current_path).to eq walks_path
        expect(page).to have_css('tr', text: '01 April 1.99')
        expect(page).to have_css('tr', text: '06 April 5.97')
        expect(page).to have_css('tr', text: '07 April 3.98')
        expect(page).to have_content('Your monthly statistics from April')
      end

      scenario 'doesnt display previous month statistics' do
        visit walks_path
        expect(page).not_to have_css('tr', text: '31 March 1.99')
      end
    end
  end
end
