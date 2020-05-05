json.extract! news_post, :id, :created_at, :updated_at
json.url news_post_url(news_post, format: :json)
