require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  describe 'POST /api/v1/posts' do
    context 'with valid params' do
      before do
        post '/api/v1/posts', params: {
          login: 'user1',
          title: 'testtitle',
          body: 'testcontent',
          ip: '192.168.0.14'
        }
      end

      it 'returns status created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct title' do
        expect(JSON.parse(response.body)['title']).to eq('testtitle')
      end
    end

    context 'without login' do
      before do
        post '/api/v1/posts', params: {
          title: 'testtitle',
          body: 'testontent',
          ip: '192.168.0.14'
        }
      end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns login error' do
        expect(JSON.parse(response.body)['error']).to eq("Login can't be blank")
      end
    end

    context 'without title' do
      before do
        post '/api/v1/posts', params: {
          login: 'user1',
          body: 'testontent',
          ip: '192.168.0.14'
        }
      end

      it 'returns status unprocessable_entity' do
      expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns login error' do
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'GET /api/v1/posts/top' do
    before do
      get '/api/v1/posts/top', params: { n: 5 }
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /api/v1/posts/ip_list' do
    before do
      get '/api/v1/posts/ip_list'
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
