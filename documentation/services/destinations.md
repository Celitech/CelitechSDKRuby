# Destinations

A list of all methods in the `Destinations` service. Click on the method name to view detailed information about that method.

| Methods                                 | Description       |
| :-------------------------------------- | :---------------- |
| [list_destinations](#list_destinations) | List Destinations |

## list_destinations

List Destinations

- HTTP Method: `GET`
- Endpoint: `/destinations`

**Parameters**

| Name   | Type   | Required | Description                                               |
| :----- | :----- | :------- | :-------------------------------------------------------- |
| config | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`ListDestinationsOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.destinations.list_destinations

puts response
```
