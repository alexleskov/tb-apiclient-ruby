# tb-apiclient-ruby
API client for Teachbase LMS

## Usage
Avaliable endpoints for usage: 
`endpoint_v1, mobile_v1, mobile_v2`

### Running the client

Endpoint v1:
`Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""`
Or you can set client_id and client_secret in config/secrets.yml

Mobile v1:
`Teachbase::API::Client.new :mobile_v1, user_email: "", password: ""`

Mobile v2:
`Teachbase::API::Client.new :mobile_v2, user_email: "", password: ""`

For success authorization in Teachbase API if you using mobile endpoints must have set accountid:
```
api = Teachbase::API::Client.new :mobile_v2, user_email: "", password: ""
api.accountid = "777"
```
It can be added in in config/secrets.yml too

### Sending reqeuest
```
api = Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""
api.request :users_sections, id:666 #where 'users_sections' is users/{user_id}/sections, and 'id:666' is user_id
```
### Getting Response
```
api = Teachbase::API::Client.new :endpoint_v1, client_id: "", client_secret: ""
api.request :users_sections, id:666
api.response #api.response.answer - return only json
```


