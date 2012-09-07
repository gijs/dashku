module.exports =
  development:
    port: 3000
    db: 'localhost/dashku_development'
    redis:
      port: 6379
      host: '127.0.0.1'
    apiUrl: 'http://localhost/api/transmission'
    apiHost: 'http://localhost/'
    forgottenPasswordUrl: 'http://localhost/?fptoken='
  cucumber:
    port: 3001
    db: 'localhost/dashku_cucumber'
    redis:
      port: 6379
      host: '127.0.0.1'
    apiUrl: 'http://localhost:3001/api/transmission'
    apiHost: 'http://localhost:3001/'
    forgottenPasswordUrl: 'http://localhost:3001/?fptoken='
  test:
    port: 3002
    db: 'localhost/dashku_test'
    redis:
      port: 6379
      host: '127.0.0.1'
    apiUrl: 'http://localhost:3002/api/transmission'
    apiHost: 'http://localhost:3002/'
    forgottenPasswordUrl: 'http://localhost:3002/?fptoken='