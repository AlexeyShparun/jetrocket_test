# Blog api

## Data Structure

### users
    ◦ id
    ◦ login (string, not null)

### posts

    ◦ user_id (not null)
    ◦ title (string, not null)
    ◦ body (text, not null)
    ◦ ip (not null)

### ratings

    ◦ post_id (not null)
    ◦ user_id (not null)
    ◦ value (integer, allowed values from 1 to 5, not null)

## Start
```
  rails db:create
  rails db:migrate
  rails s
  rails db:seed
```

## For curl testing use it(after starting rails s):

#### Successful request:

    curl -X POST http://localhost:3000/api/v1/posts \
    -H "Content-Type: application/json" \
    -d '{
        "login": "user1",
        "title": "testpost",
        "body": "testbody",
        "ip": "192.168.1.100"
    }'

#### List of IPs that were posted by several different authors:

    curl -X GET http://localhost:3000/api/v1/posts/ip_list

#### Rate post(for a "repeat rate" error, repeat it x2):

    curl -X POST http://localhost:3000/api/v1/ratings \
    -H "Content-Type: application/json" \
    -d '{
        "post_id": 1,
        "user_id": 1,
        "value": 5
    }'

## Warning! Generating 200000 posts will take a very long time. To improve it I decided to use httparty.