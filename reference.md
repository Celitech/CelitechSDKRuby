# Reference

## Destinations

### `celitech.destinations.list_destinations`

`GET /destinations`

List Destinations

## Packages

### `celitech.packages.list_packages`

`GET /packages`

List Packages

**Parameters:**

- `destination`
- `data_limit_in_gb`
- `start_date`
- `end_date`
- `after_cursor`
- `limit`
- `start_time`
- `end_time`
- `include_unlimited`

## Purchases

### `celitech.purchases.create_purchase_v2`

`POST /purchases/v2`

Create Purchase V2

### `celitech.purchases.list_purchases`

`GET /purchases`

List Purchases

**Parameters:**

- `purchase_id`
- `iccid`
- `after_date`
- `before_date`
- `email`
- `reference_id`
- `after_cursor`
- `limit`
- `after`
- `before`

### `celitech.purchases.create_purchase`

`POST /purchases`

Create Purchase

### `celitech.purchases.top_up_esim`

`POST /purchases/topup`

Top-up eSIM

### `celitech.purchases.edit_purchase`

`POST /purchases/edit`

Edit Purchase

### `celitech.purchases.get_purchase_consumption`

`GET /purchases/{purchaseId}/consumption`

Get Purchase Consumption

**Parameters:**

- `purchase_id` (required)

## ESim

### `celitech.e_sim.get_esim`

`GET /esim`

Get eSIM

**Parameters:**

- `iccid` (required)

### `celitech.e_sim.get_esim_device`

`GET /esim/{iccid}/device`

Get eSIM Device

**Parameters:**

- `iccid` (required)

### `celitech.e_sim.get_esim_history`

`GET /esim/{iccid}/history`

Get eSIM History

**Parameters:**

- `iccid` (required)

### `celitech.e_sim.suspend_esim`

`POST /esim/{iccid}/suspend`

Suspend eSIM

**Parameters:**

- `iccid` (required)

## IFrame

### `celitech.i_frame.token`

`POST /iframe/token`

Generate Token

## OAuth

### `celitech.o_auth.get_access_token`

`POST /oauth2/token`
