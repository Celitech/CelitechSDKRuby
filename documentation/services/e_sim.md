# ESim

A list of all methods in the `ESim` service. Click on the method name to view detailed information about that method.

| Methods                               | Description      |
| :------------------------------------ | :--------------- |
| [get_esim](#get_esim)                 | Get eSIM         |
| [get_esim_device](#get_esim_device)   | Get eSIM Device  |
| [get_esim_history](#get_esim_history) | Get eSIM History |

## get_esim

Get eSIM

- HTTP Method: `GET`
- Endpoint: `/esim`

**Parameters**

| Name   | Type   | Required | Description                                               |
| :----- | :----- | :------- | :-------------------------------------------------------- |
| iccid  | String | ✅       | ID of the eSIM                                            |
| config | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`GetEsimOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.e_sim.get_esim(iccid: '1111222233334444555000')

puts response
```

## get_esim_device

Get eSIM Device

- HTTP Method: `GET`
- Endpoint: `/esim/{iccid}/device`

**Parameters**

| Name   | Type   | Required | Description                                               |
| :----- | :----- | :------- | :-------------------------------------------------------- |
| iccid  | String | ✅       | ID of the eSIM                                            |
| config | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`GetEsimDeviceOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.e_sim.get_esim_device(iccid: '1111222233334444555000')

puts response
```

## get_esim_history

Get eSIM History

- HTTP Method: `GET`
- Endpoint: `/esim/{iccid}/history`

**Parameters**

| Name   | Type   | Required | Description                                               |
| :----- | :----- | :------- | :-------------------------------------------------------- |
| iccid  | String | ✅       | ID of the eSIM                                            |
| config | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`GetEsimHistoryOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.e_sim.get_esim_history(iccid: '1111222233334444555000')

puts response
```
