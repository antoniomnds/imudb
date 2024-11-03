require 'rails_helper'

RSpec.describe "Albums Request", type: :request do
  describe "Unauthorized access to albums" do
    it "denies access to albums#me" do
      get me_api_v1_albums_path

      expect(response).to have_http_status(:unauthorized)
    end

    it "denies access to albums#show" do
      # TODO
    end
  end

  describe "Authorized access to albums" do
    let(:albums) { create_list(:album, 5) }
    let(:user) { create(:user) }
    let(:token) { create(:oauth_access_token, user:) }

    before do
      allow(AlbumsService).to receive(:saved_albums).with(user, false).and_return(albums)
      allow(JwtService).to receive(:decode).and_return(token.access_token)
    end

    it "returns saved albums" do
      get me_api_v1_albums_path, headers: { "HTTP_AUTHORIZATION": "Bearer #{ token.access_token }" }

      expect(response).to have_http_status(:ok)
      expect(AlbumsService).to have_received(:saved_albums).with(user, false)
    end

    # TODO test endpoint show
    # TODO test endpoint similar
    # TODO test endpoint create
  end
end
