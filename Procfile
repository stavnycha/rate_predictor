web: bundle exec ./bin/rails s -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -c 10 -e ${RACK_ENV:-development} -q default
release: rake db:migrate