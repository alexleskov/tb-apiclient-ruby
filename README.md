# tb-apiclient-ruby
API client for Teachbase LMS

## Usage
Avaliable endpoints for usage: 
`endpoint_v1, mobile_v1, mobile_v2`

### Running the client

Endpoint v1:

```ruby
Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""
```

Or you can set client_id and client_secret in config/secrets.yml

Mobile v1:

```ruby
Teachbase::API::Client.new :mobile_v1, user_login: "", password: ""
```

Mobile v2:

```ruby
Teachbase::API::Client.new :mobile_v2, user_login: "", password: ""
```

On mobile API user_login it's email or phone number.
For success authorization in Teachbase API if you are using mobile endpoints must have set up 'account_id':

```ruby
Teachbase::API::Client.new :mobile_v2, account_id: "", user_login: "", password: ""
```

It can be setted in config/secrets.yml or on request sending params.


### Sending Request

```ruby
api = Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""
api.request "users_sections", id:666

# where 'users_sections' is users/{user_id}/sections, and 'id:666' is user id
# https://go.teachbase.ru/api-docs/index.html#/competences/get_users__id__sections

api = Teachbase::API::Client.new :mobile_v2, account_id: "", user_login: "", password: ""
api.request "course-sessions_materials", cs_id:111, m_id:222

# where 'course-sessions_materials' is /course_sessions/{session_id}/materials/{id}, and 'cs_id:111' is session_id, m_id:222 is material's id
# https://go.teachbase.ru/api-docs/index.html?urls.primaryName=Mobile#/materials/get_course_sessions__session_id__materials__id_
```
See more about other methods in API docs: https://go.teachbase.ru/api-docs/

Every Request has several params:
```ruby
:response, :client, :method_name, :request_url, :request_params, :url_ids, :account_id
```

### Getting Response

```ruby
api = Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""
api.request "users_sections", id:666
api.response #api.response.answer - return only json
```

## Available methods
In progess. Look for available methods in 'endpoints' folder.
