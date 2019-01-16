require 'rails_helper'

RSpec.describe 'Admin::Teams', type: :request do
  let(:instance) { teams.first }
  let(:model) { Team }
  let(:model_string) { model.to_s }
  let(:photo) do
     "data:image/png;base64," + photo_data
  end
  let(:photo_data) { Base64.encode64(file_fixture("flag_pl.png").read) }
  let!(:teams) { create_list(:team, 2) }
  let(:team) { teams.first }
  let(:type) { model.to_s.pluralize.underscore.dasherize }
  let!(:user_admin) { create(:user, :admin) }
  let!(:user_registered) { create(:user, :registered) }

  let(:params) do
    {
      data: {
        type: type,
        attributes: attributes
      }
    }
  end

  context 'admin namespace' do
    context 'not logged in' do
      let(:auth_headers) { {} }
      include_examples 'unauthorized_requests'
    end

    context 'registered user logged in' do
      before do
        @logged_in_response = login(user_registered)
      end

      let(:auth_headers) { get_auth_headers(@logged_in_response) }

      include_examples 'unauthorized_requests'
    end

    context 'admin logged in' do
      before do
        logged_in_response = login(user_admin)
        @auth_headers = get_auth_headers(logged_in_response)
      end

      describe 'GET /admin/teams' do
        let(:index_request) do
          get '/admin/teams',
              headers: @auth_headers
        end

        it 'returns all instances' do
          index_request
          expect(response).to have_http_status(200)
          expect(json_data.size).to eq model.all.count
        end
      end

      describe 'GET /admin/team/:id' do
        context 'with valid id' do
          let(:show_request) do
            get "/admin/teams/#{team.id}",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(200)
            expect(json_data['id']).to eq(team.id.to_s)
          end
        end

        context 'with invalid id' do
          let(:show_request) do
            get "/admin/teams/0",
                headers: @auth_headers
          end

          it 'returns team with id provided' do
            show_request
            expect(response).to have_http_status(404)
            expect(json).to eq "message" => "Couldn't find #{model} with 'id'=0"
          end
        end
      end

      describe 'POST /admin/teams' do
        let(:post_request) do
          post '/admin/teams',
               params: params,
               headers: @auth_headers
        end

        context 'valid data' do
          let(:attributes) do
            {
              'name': 'Nowy zespol',
              'name_en': 'New team',
              'photo': photo
            }
          end

          it 'creates new team' do
            expect { post_request }.to change { Team.count }.by(1)
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('Nowy zespol')
            expect(json_attributes['photo']['url']).to be
          end
        end

        context 'invalid data' do
          let(:attributes) do
            {
              'name': '',
              'name_en': ''
            }
          end

          it 'does not create new team' do
            expect { post_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end

      end

      describe 'PATCH /admin/team/:id' do
        let(:patch_request) do
          patch "/admin/teams/#{team.id}",
                params: params,
                headers: @auth_headers
        end

        context 'with valid data' do
          let(:attributes)  do
            { "name": "New name" }
          end

          it 'updates team' do
            patch_request
            expect(response).to have_http_status(200)
            expect(json_attributes['name']).to eq('New name')
          end
        end

        context 'with invalid data' do
          let(:attributes) do
            {
              "name": '',
              "name_en": ''
            }
          end

          it 'does not update team' do
            patch_request
            expect(response).to have_http_status(422)
            expect(json).to eq(
              { "message" => "Negatywne sprawdzenie poprawności: Nazwa nie może być puste" }
            )
          end
        end
      end

      describe 'DELETE /admin/team/:id' do
        context 'valid params' do
          let(:delete_request) do
            delete "/admin/teams/#{team.id}",
                  headers: @auth_headers
          end

          it 'removes team' do
            expect { delete_request }.to change { Team.count }.by(-1)
            expect(response).to have_http_status(204)
          end
        end

        context 'invalid params' do
          let(:delete_request) do
            delete "/admin/teams/0",
                  headers: @auth_headers
          end

          it 'does not remove team' do
            expect { delete_request }.to change { Team.count }.by(0)
            expect(response).to have_http_status(404)
            expect(json).to eq({"message"=>"Couldn't find #{model_string} with 'id'=0"})
          end
        end
      end
    end
  end
end
