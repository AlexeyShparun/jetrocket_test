require 'rails_helper'

RSpec.describe 'Ratings API', type: :request do
  let(:user) { User.create!(login: 'testuser') }
  let(:new_post) { Post.create!(title: 'testtitle', body: 'testcontentt', ip: '192.168.0.15', user: user) }

  describe 'POST /api/v1/ratings' do
    context 'with valid data' do
      it 'creates rating' do
        post '/api/v1/ratings',
             params: {
               post_id: new_post.id,
               user_id: user.id,
               value: 5
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['average_rating']).to eq(5.0)
      end
    end

    context 'with invalid data' do
      it 'returns error if post doesnt exist' do
        post '/api/v1/ratings',
             params: {
               post_id: 9000000,
               user_id: user.id,
               value: 5
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Post not found')
      end

      it 'returns error if duplicate rating' do
        post '/api/v1/ratings',
             params: {
               post_id: new_post.id,
               user_id: user.id,
               value: 4
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }

        post '/api/v1/ratings',
             params: {
               post_id: new_post.id,
               user_id: user.id,
               value: 3
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('User has already rated this post')
      end

      it 'returns error if value invalid' do
        post '/api/v1/ratings',
             params: {
               post_id: new_post.id,
               user_id: user.id,
               value: 6
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Value must be less than or equal to 5')
      end
    end
  end
end

#у меня ошибки по рубокопу, однако когда правил - наделал ошибок, решил оставить так пока и подумать