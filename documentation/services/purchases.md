# Purchases

A list of all methods in the `Purchases` service. Click on the method name to view detailed information about that method.

| Methods                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| :---------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [create_purchase_v2](#create_purchase_v2)             | This endpoint is used to purchase a new eSIM by providing the package details.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| [list_purchases](#list_purchases)                     | This endpoint can be used to list all the successful purchases made between a given interval.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| [create_purchase](#create_purchase)                   | This endpoint is used to purchase a new eSIM by providing the package details.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| [top_up_esim](#top_up_esim)                           | This endpoint is used to top-up an existing eSIM with the previously associated destination by providing its ICCID and package details. To determine if an eSIM can be topped up, use the Get eSIM endpoint, which returns the `isTopUpAllowed` flag.                                                                                                                                                                                                                                                                                                                                                                                                    |
| [edit_purchase](#edit_purchase)                       | This endpoint allows you to modify the validity dates of an existing purchase. **Behavior:** - If the purchase has **not yet been activated**, both the start and end dates can be updated. - If the purchase is **already active**, only the **end date** can be updated, while the **start date must remain unchanged** (and should be passed as originally set). - Updates must comply with the same pricing structure; the modification cannot alter the package size or change its duration category. The end date can be extended or shortened as long as it adheres to the same pricing category and does not exceed the allowed duration limits. |
| [get_purchase_consumption](#get_purchase_consumption) | This endpoint can be called for consumption notifications (e.g. every 1 hour or when the user clicks a button). It returns the data balance (consumption) of purchased packages.                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

## create_purchase_v2

This endpoint is used to purchase a new eSIM by providing the package details.

- HTTP Method: `POST`
- Endpoint: `/purchases/v2`

**Parameters**

| Name   | Type                    | Required | Description                                               |
| :----- | :---------------------- | :------- | :-------------------------------------------------------- |
| body   | CreatePurchaseV2Request | ✅       | The request body.                                         |
| config | Config                  | ❌       | Override the client-level config for this single request. |

**Return Type**

`Array<CreatePurchaseV2OkResponse>`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.create_purchase_v2(body: { 'destination' => 'FRA', 'dataLimitInGB' => 1, 'quantity' => 1 })

puts response
```

## list_purchases

This endpoint can be used to list all the successful purchases made between a given interval.

- HTTP Method: `GET`
- Endpoint: `/purchases`

**Parameters**

| Name         | Type   | Required | Description                                                                                                                                                                                                         |
| :----------- | :----- | :------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| purchase_id  | String | ❌       | ID of the purchase                                                                                                                                                                                                  |
| iccid        | String | ❌       | ID of the eSIM                                                                                                                                                                                                      |
| after_date   | String | ❌       | Start date of the interval for filtering purchases in the format 'yyyy-MM-dd'                                                                                                                                       |
| before_date  | String | ❌       | End date of the interval for filtering purchases in the format 'yyyy-MM-dd'                                                                                                                                         |
| email        | String | ❌       | Email associated to the purchase.                                                                                                                                                                                   |
| reference_id | String | ❌       | The referenceId that was provided by the partner during the purchase or topup flow.                                                                                                                                 |
| after_cursor | String | ❌       | To get the next batch of results, use this parameter. It tells the API where to start fetching data after the last item you received. It helps you avoid repeats and efficiently browse through large sets of data. |
| limit        | String | ❌       | Maximum number of purchases to be returned in the response. The value must be greater than 0 and less than or equal to 100. If not provided, the default value is 20                                                |
| after        | String | ❌       | Epoch value representing the start of the time interval for filtering purchases                                                                                                                                     |
| before       | String | ❌       | Epoch value representing the end of the time interval for filtering purchases                                                                                                                                       |
| config       | Config | ❌       | Override the client-level config for this single request.                                                                                                                                                           |

**Return Type**

`ListPurchasesOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.list_purchases

puts response
```

## create_purchase

This endpoint is used to purchase a new eSIM by providing the package details.

- HTTP Method: `POST`
- Endpoint: `/purchases`

**Parameters**

| Name   | Type                  | Required | Description                                               |
| :----- | :-------------------- | :------- | :-------------------------------------------------------- |
| body   | CreatePurchaseRequest | ✅       | The request body.                                         |
| config | Config                | ❌       | Override the client-level config for this single request. |

**Return Type**

`CreatePurchaseOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.create_purchase(body: { 'destination' => 'FRA', 'dataLimitInGB' => 1, 'startDate' => '2023-11-01', 'endDate' => '2023-11-20' })

puts response
```

## top_up_esim

This endpoint is used to top-up an existing eSIM with the previously associated destination by providing its ICCID and package details. To determine if an eSIM can be topped up, use the Get eSIM endpoint, which returns the `isTopUpAllowed` flag.

- HTTP Method: `POST`
- Endpoint: `/purchases/topup`

**Parameters**

| Name   | Type             | Required | Description                                               |
| :----- | :--------------- | :------- | :-------------------------------------------------------- |
| body   | TopUpEsimRequest | ✅       | The request body.                                         |
| config | Config           | ❌       | Override the client-level config for this single request. |

**Return Type**

`TopUpEsimOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.top_up_esim(body: { 'iccid' => '1111222233334444555000', 'dataLimitInGB' => 1 })

puts response
```

## edit_purchase

This endpoint allows you to modify the validity dates of an existing purchase. **Behavior:** - If the purchase has **not yet been activated**, both the start and end dates can be updated. - If the purchase is **already active**, only the **end date** can be updated, while the **start date must remain unchanged** (and should be passed as originally set). - Updates must comply with the same pricing structure; the modification cannot alter the package size or change its duration category. The end date can be extended or shortened as long as it adheres to the same pricing category and does not exceed the allowed duration limits.

- HTTP Method: `POST`
- Endpoint: `/purchases/edit`

**Parameters**

| Name   | Type                | Required | Description                                               |
| :----- | :------------------ | :------- | :-------------------------------------------------------- |
| body   | EditPurchaseRequest | ✅       | The request body.                                         |
| config | Config              | ❌       | Override the client-level config for this single request. |

**Return Type**

`EditPurchaseOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.edit_purchase(body: { 'purchaseId' => 'ae471106-c8b4-42cf-b83a-b061291f2922', 'startDate' => '2023-11-01', 'endDate' => '2023-11-20' })

puts response
```

## get_purchase_consumption

This endpoint can be called for consumption notifications (e.g. every 1 hour or when the user clicks a button). It returns the data balance (consumption) of purchased packages.

- HTTP Method: `GET`
- Endpoint: `/purchases/{purchaseId}/consumption`

**Parameters**

| Name        | Type   | Required | Description                                               |
| :---------- | :----- | :------- | :-------------------------------------------------------- |
| purchase_id | String | ✅       | ID of the purchase                                        |
| config      | Config | ❌       | Override the client-level config for this single request. |

**Return Type**

`GetPurchaseConsumptionOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.purchases.get_purchase_consumption(purchase_id: '4973fa15-6979-4daa-9cf3-672620df819c')

puts response
```
