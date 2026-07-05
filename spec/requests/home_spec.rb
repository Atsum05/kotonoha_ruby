require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "shows the Sobre Kotonoha button linking to the about page" do
      get root_path
      expect(response.body).to include("Sobre Kotonoha")
      expect(response.body).to include(about_path)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end
end
