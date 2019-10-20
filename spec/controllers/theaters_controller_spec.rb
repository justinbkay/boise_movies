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

  describe "GET #edit" do
    it "returns http success" do
      theater = create :theater
      get :edit, params: { id: theater.id }, session: { admin: 1 }
      expect(response).to have_http_status(:success)
    end
  end

end
