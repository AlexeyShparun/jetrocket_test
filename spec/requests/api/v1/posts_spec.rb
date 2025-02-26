require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  it 'creates post' do
    post '/api/v1/posts', params: {
      login: 'user1',
      title: 'testtitle',
      body: 'testcontent',
      ip: '192.168.0.14'
    }
    
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['title']).to eq('testtitle')
  end

  it 'returns error without login' do
    post '/api/v1/posts', params: {
      title: 'testtitle',
      body: 'testontent',
      ip: '192.168.0.14'
    }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['error']).to eq("Login can't be blank")
  end

  it 'returns error without title' do
    post '/api/v1/posts', params: {
      login: 'user1',
      body: 'testcontent',
      ip: '192.168.0.14'
    }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
  end

end


#у меня ошибки по рубокопу, однако когда правил - наделал ошибок, решил оставить так пока