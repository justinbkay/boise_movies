require 'rails_helper'

RSpec.describe TheatersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index, params: {}, session: { admin: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new, params: {}, session: { admin: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, params: { theater: { name: 'Test Theater', imdb_name: 'Testthel' } }, session: { admin: 1 }
      t_count = Theater.count
      expect(t_count).to eq(1)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'POST #create' do
    it 'returns the theater form' do
      post :create, params: { theater: { name: '', imdb_name: '' } }, session: { admin: 1 }
      t_count = Theater.count
      expect(t_count).to eq(0)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      theater = create :theater
      get :edit, params: { id: theater.id }, session: { admin: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    it 'updates a theater successfully' do
      theater = create :theater
      patch :update, params: { id: theater.id, theater: { name: 'Theater one two' } }, session: { admin: 1 }
      theater.reload
      expect(theater.name).to eq('Theater one two')
    end
  end

  describe 'PATCH #update' do
    it 'returns the edit form on failure to save' do
      theater = create :theater
      patch :update, params: { id: theater.id, theater: { name: '' } }, session: { admin: 1 }
      expect(response).to render_template(:edit)
    end
  end
end
