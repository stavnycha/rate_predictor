unless Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = { size: 20, url: ENV['REDIS_URL'] || 'redis://127.0.0.1:6379' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { size: 2, url: ENV['REDIS_URL'] || 'redis://127.0.0.1:6379' }
  end
end
