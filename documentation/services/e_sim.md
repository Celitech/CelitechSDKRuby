# ESim

A list of all methods in the `ESim` service. Click on the method name to view detailed information about that method.

| Methods                               | Description                                                                                                                                                    |
| :------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [get_esim](#get_esim)                 | Get eSIM                                                                                                                                                       |
| [get_esim_device](#get_esim_device)   | Get eSIM Device                                                                                                                                                |
| [get_esim_history](#get_esim_history) | Get eSIM History                                                                                                                                               |
| [suspend_esim](#suspend_esim)         | Suspends an eSIM to prevent abuse. All of the eSIM's packages are terminated and its connectivity is switched off. The eSIM is not refunded: the charge stays. |

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

## suspend_esim

Suspends an eSIM to prevent abuse. All of the eSIM's packages are terminated and its connectivity is switched off. The eSIM is not refunded: the charge stays.

- HTTP Method: `POST`
- Endpoint: `/esim/{iccid}/suspend`

**Parameters**

| Name            | Type   | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| :-------------- | :----- | :------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| iccid           | String | ✅       | ID of the eSIM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| idempotency_key | String | ❌       | Optional. A unique value (for example a UUID) that makes this request safe to retry. If a request with the same `Idempotency-Key` and the same body succeeds, repeating it returns the original response instead of performing the action again, and the response includes the header `Idempotent-Replayed: true`. Keys are scoped to your credentials and remembered for 3 days. Only successful (2xx) responses are remembered, so a request that failed can be retried with the same key. Reusing a key with a different request returns `422`; sending it while the original request is still being processed returns `409`. If the idempotency store is temporarily unavailable, the request is not processed and returns `503`; retry it. Must be 1 to 255 printable ASCII characters, without spaces. |
| config          | Config | ❌       | Override the client-level config for this single request.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

**Return Type**

`SuspendEsimOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.e_sim.suspend_esim(iccid: '1111222233334444555000')

puts response
```
