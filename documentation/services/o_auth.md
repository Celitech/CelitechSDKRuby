# OAuth

A list of all methods in the `OAuth` service. Click on the method name to view detailed information about that method.

| Methods                               | Description |
| :------------------------------------ | :---------- |
| [get_access_token](#get_access_token) |             |

## get_access_token

- HTTP Method: `POST`
- Endpoint: `/oauth2/token`

**Parameters**

| Name   | Type              | Required | Description                                               |
| :----- | :---------------- | :------- | :-------------------------------------------------------- |
| body   | OAuthTokenRequest | ✅       | The request body.                                         |
| config | Config            | ❌       | Override the client-level config for this single request. |

**Return Type**

`OAuthTokenResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.o_auth.get_access_token(body: { 'grant_type' => 'client_credentials', 'client_id' => 'your_client_id', 'client_secret' => 'your_client_secret', 'scope' => 'read write' })

puts response
```
