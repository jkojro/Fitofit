require 'rails_helper'

describe WalksController, type: :controller do
  describe 'GET #new' do
    let(:action) { get :new }
    it 'renders the :new view' do
      action
      expect(response.status).to eq(200)
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: { walk: params } }

    context 'with valid attributes' do
      let(:params) { { start_location: 'Dąbrowskiego 15, Warszawa, Polska', end_location: 'Białostoska 1, Warszawa, Polska' } }

      it 'response with status 200' do
        expect(response.status).to eq(200)
      end

      it 'creates walk' do
        expect { action }.to change { Walk.count }.by(1)
      end
    end

    context 'with invalid attributes' do
      let!(:params) { { start_location: 'Dąbrowskiego 15 55, Warszawa, Polska', end_location: 'Białostoska 1, Warszawa' } }

      it 'response with status 200' do
        expect(response.status).to eq(200)
      end

      it 'doesnt create walk with valid attributes' do
        expect { action }.to change { Walk.count }.by(0)
      end
    end
  end

  describe 'GET #show' do
    let(:walk) { FactoryBot.create(:walk) }
    let(:action) { get :show, params: { id: walk.id } }

    it 'renders the :show view' do
      action
      expect(response.status).to eq(200)
      expect(response).to render_template :show
    end

    it 'shows last week distance' do
      this_week_walks = FactoryBot.create_list(:walk, 3)
      last_week_walks = FactoryBot.create_list(:walk, 2, created_at: 1.week.ago)
      action
      assigns(:this_week_walks_distance).should eq(this_week_walks.sum(&:distance))
    end
  end
end
