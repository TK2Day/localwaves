web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
redis: redis-server
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=8 QUEUE=* bundle exec rake resque:work
