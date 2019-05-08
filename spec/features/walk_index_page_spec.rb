require 'rails_helper'

describe WalksController, :vcr, type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:actual_month) { Date.today.month }
  let(:month_in_word) { Date::MONTHNAMES[actual_month] }
  before { sign_in user }

  describe '#index' do
    context 'statistics' do
      before do
        FactoryBot.create_list(:walk, 1, created_at: "2019-#{actual_month}-07")
        FactoryBot.create_list(:walk, 2, created_at: "2019-#{actual_month}-07", user_id: user.id)
        FactoryBot.create_list(:walk, 3, created_at: "2019-#{actual_month}-06", user_id: user.id)
        FactoryBot.create_list(:walk, 1, created_at: "2019-#{actual_month}-01", user_id: user.id)
        FactoryBot.create_list(:walk, 1, created_at: '2019-03-31', user_id: user.id)
      end

      scenario 'display actual month name' do
        visit walks_path
        expect(page).to have_content("Your monthly statistics from #{Date::MONTHNAMES[Date.today.month]}")
      end

      scenario 'display actual month statistisc' do
        visit walks_path
        expect(page.current_path).to eq walks_path
        expect(page).to have_css('tr', text: "01 #{month_in_word} 2.36")
        expect(page).to have_css('tr', text: "06 #{month_in_word} 7.08")
        expect(page).to have_css('tr', text: "07 #{month_in_word} 4.72")
      end

      scenario 'doesnt display other month statistics' do
        visit walks_path
        expect(page).not_to have_css('tr', text: '31 March 1.99')
      end
    end
  end
end
