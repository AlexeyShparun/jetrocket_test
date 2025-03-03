# решил заюзать httparty т.к. через curl производительность была ужасная, с httparty чуть быстрее(всё ещё ад), пытался юзануть parallel, чёт баги летели
require 'faker'
require 'httparty'

API_URL = 'http://localhost:3000/api/v1'
POSTS_COUNT = 200_000
USERS_COUNT = 100
IPS_COUNT = 50
RATED_POSTS_RATIO = 0.75

ips = Array.new(IPS_COUNT) { Faker::Internet.unique.ip_v4_address } # 50 айпишников

# posts and usr creating
USERS_COUNT.times do
  HTTParty.post(
    "#{API_URL}/posts",
    body: {
      login: Faker::Internet.unique.username,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      ip: ips.sample
    }.to_json,
    headers: { 'Content-Type' => 'application/json' },
    timeout: 5
  )
end

# user crt
(POSTS_COUNT - USERS_COUNT).times do
  HTTParty.post(
    "#{API_URL}/posts",
    body: {
      login: User.all.sample.login,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      ip: ips.sample
    }.to_json,
    headers: { 'Content-Type' => 'application/json' },
    timeout: 5
  )
end

# add rating
post_ids = Post.ids.sample((POSTS_COUNT * RATED_POSTS_RATIO).to_i)

post_ids.each do |post_id|
  HTTParty.post(
    "#{API_URL}/ratings",
    body: {
      post_id: post_id,
      user_id: User.all.sample.id,
      value: rand(1..5)
    }.to_json,
    headers: { 'Content-Type' => 'application/json' },
    timeout: 5
  )
end
