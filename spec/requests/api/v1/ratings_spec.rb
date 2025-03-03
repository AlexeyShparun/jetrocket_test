require 'rails_helper'

RSpec.describe 'Ratings API', type: :request do
  let(:user) { User.create!(login: 'testuser') }
  let(:new_post) { Post.create!(title: 'testtitle', body: 'testcontentt', ip: '192.168.0.15', user: user) }

  describe 'POST /api/v1/ratings' do
    context 'with valid data' do
      before do
        post '/api/v1/ratings',
             params: {
               post_id: new_post.id,
               user_id: user.id,
               value: 5
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }
      end

      it 'creates rating' do
        expect(response).to have_http_status(:created)
      end

      it 'update average rating' do
        expect(JSON.parse(response.body)['average_rating']).to eq(5.0)
      end
    end

    context 'with invalid data' do
      before do
        post '/api/v1/ratings',
             params: {
               post_id: 9_000_000,
               user_id: user.id,
               value: 5
             }.to_json,
             headers: { 'Content-Type' => 'application/json' }
      end

      it 'returns status not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns post not found' do
        expect(JSON.parse(response.body)['error']).to eq('Post not found')
      end
    end


    context 'when duplicate rating' do
      before do
        2.times do
          post '/api/v1/ratings',
              params: {
                post_id: new_post.id,
                user_id: user.id,
                value: 4
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
        end
      end

      it 'returns conflict status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns duplication error' do
        expect(JSON.parse(response.body)['error']).to eq('User has already rated this post')
      end
    end

    context 'when value invalid' do
      before do
        post '/api/v1/ratings',
              params: {
                post_id: new_post.id,
                user_id: user.id,
                value: 6
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
      end

      it 'returns conflict status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns value error' do
        expect(JSON.parse(response.body)['errors']).to include('Value must be less than or equal to 5')
      end
    end
  end
end
