# IFrame

A list of all methods in the `IFrame` service. Click on the method name to view detailed information about that method.

| Methods         | Description                                   |
| :-------------- | :-------------------------------------------- |
| [token](#token) | Generate a new token to be used in the iFrame |

## token

Generate a new token to be used in the iFrame

- HTTP Method: `POST`
- Endpoint: `/iframe/token`

**Parameters**

| Name   | Type   | Required | Description                                               |
| :----- | :----- | :------- | :-------------------------------------------------------- |
| config | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`TokenOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.i_frame.token

puts response
```
