# tb-apiclient-ruby

API client for Teachbase LMS


## Usage

Avaliable APIs and versions for usage: 
`endpoint: v1
 mobile: v1, v2`


### Running the client

Avaliable options for Client:

* API type: `:endpoint` or `:mobile`
* API version: `1` or `2`

Other params:
```ruby
:client_id, :client_secret, :user_login, :password, :account_id, :token_expiration_time, :rest_client, :lms_host
```

Can be setted in config/secrets.yml:
`client_id`, `client_secret`, `account_id`, `token_expiration_time`, `rest_client`, `lms_host` 

Default `token_time_limit` = `7200` seconds.


#### Examples

Endpoint v1:

```ruby
Teachbase::API::Client.new(:endpoint, 1, client_id: "", client_secret: "")
```

Mobile v1:

```ruby
Teachbase::API::Client.new(:mobile, 1, client_id: "", client_secret: "", user_login: "", password: "")
```

Mobile v2:

```ruby
Teachbase::API::Client.new(:mobile, 2, client_id: "", client_secret: "", user_login: "", password: "")
```

On mobile API `user_login` is email or phone number.

For success authorization in `mobile` Teachbase API must have set up `account_id`:

```ruby
Teachbase::API::Client.new(:mobile, 2, client_id: "", client_secret: "", user_login: "", password: "", account_id: "")
```


### Creating and sending the request

Requests can sended with: `get`, `post`, `patch`, `delete` http methods.

Avaliable options for Request:

* Method class
* Method path

Other params:
```ruby
:answer_type (:raw, :json, :object), :payload
```

Default answer type is `:json`

Default payload type is `:json`


#### Examples

1. Running the client:
```ruby
api = Teachbase::API::Client.new(:mobile, 2, client_id: "", client_secret: "", user_login: "", password: "")
```

2. Creating the request
`api.request(<method_class>, <method_path>, <options>)`

```ruby
request = client.request(:notification_settings, :profile_notification_settings)
```

For `patch` or `post` methods you can set up `payload`.

```ruby
payload = { "courses": true, "news": true, "tasks": true, "quizzes": true, "programs": true, "webinars": true }
request = client.request(:notification_settings, :profile_notification_settings, payload: payload, answer_type: :raw)
```

3. Sending the request
`request.post / request.get / request.patch / request.delete`


### More examples

```ruby
api = Teachbase::API::Client.new(:mobile, 2, client_id: "", client_secret: "", user_login: "", password: "")

api.request(:materials, :course_sessions_materials, session_id: 111, id: 222).get
# GET /course_sessions/{session_id}/materials/{id}
# https://go.teachbase.ru/api-docs/index.html?urls.primaryName=Mobile#/materials/get_course_sessions__session_id__materials__id_

api.request(:course_sessions, :course_sessions, filter: :active, page: 1, per_page: 100).get
# /course_sessions
# https://go.teachbase.ru/api-docs/index.html?urls.primaryName=Mobile#/

api.request(:quizzes, :course_sessions_quizzes_start, course_session_id: 111, id: 222).post

# POST /course_sessions/{course_session_id}/quizzes/{id}/start
# https://go.teachbase.ru/api-docs/index.html?urls.primaryName=Mobile#/quizzes/post_course_sessions__course_session_id__quizzes__id__start
```

See more about other methods in API docs: https://go.teachbase.ru/api-docs/


## Available methods

Looking for available methods in `api_types/versions` folder.


## Extra

If you want to get response's headers:
```ruby
api = Teachbase::API::Client.new(:mobile, 2, client_id: "", client_secret: "", user_login: "", password: "")
response = api.request(:course_sessions, :course_sessions, filter: :active, page: 1, per_page: 100, answer_type: :raw).get # get raw response
response.headers
```
