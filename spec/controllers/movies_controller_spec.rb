require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  # rspec bug causing failures
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "excorcise private method" do
    it "counts the number of movies by rating" do
      movie = create(:movie)
      movies = [movie]
      @controller = MoviesController.new
      count = @controller.instance_eval{ make_count(movies) }
      expect(count).to eq({"R"=>1})
    end
  end

end
