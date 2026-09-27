# Celitech Ruby SDK 2.0.8

Welcome to the Celitech SDK documentation. This guide will help you get started with integrating and using the Celitech SDK in your project.

## Versions

- API version: `2.0.8`
- SDK version: `2.0.8`

## About the API

Welcome to the CELITECH API documentation!

Useful links: [Homepage](https://www.celitech.com) | [Support email](mailto:devops@celitech.com) | [Blog](https://www.celitech.com/blog/)

# Introduction

This guide is your go-to resource for the CELITECH API, with full documentation and schemas.

Need help? Email us at devops@celitech.com.

"Partners" refers to online service providers that use our eSIM API. Access levels include Gold, Platinum, and Diamond.

## API

The CELITECH API is designed for use by partner platforms, including both web and mobile applications. It's assumed all endpoint calls are initiated from the backend of an integrated platform.

API URL: `https://api.celitech.net/v1`

## Authentication & Authorization

CELITECH API uses the OAuth 2.0 protocol for authentication and authorization.
The endpoints are protected using client credentials flow which is based on a token exchange. The token has a defined life span (typically 1 hour), after which a new token must be obtained.

To begin, obtain OAuth 2.0 client credentials ( **CLIENT_ID** & **CLIENT_SECRET** ) from the [CELITECH Dashboard](https://www.dashboard.celitech.com/). Then your client application requests an access token from the CELITECH Authorization Server, extracts a token from the response, and sends the token to the CELITECH API that you want to access.

Security Scheme Type: `OAuth2`

Flow type: `clientCredentials`

Token URL: `https://auth.celitech.net/oauth2/token`

## Table of Contents

- [Setup & Configuration](#setup--configuration)
  - [Supported Language Versions](#supported-language-versions)
  - [Installation](#installation)
- [Authentication](#authentication)
  - [OAuth Authentication](#oauth-authentication)
  - [Environment Variables](#environment-variables)
- [Sample Usage](#sample-usage)
- [Services](#services)
- [Models](#models)
- [License](#license)

# Setup & Configuration

## Supported Language Versions

This SDK is compatible with the following versions: `Ruby >= 3.3`

## Installation

### Using RubyGems

If the gem is published to RubyGems or a private gem server, install it directly:

```bash
gem install celitech
```

### Using Bundler (recommended)

Add the gem to your application's `Gemfile`:

```ruby
gem 'celitech'
```

Then run:

```bash
bundle install
```

## Verifying the SDK setup

To verify the SDK works correctly, you can run the included example:

1. Install dependencies:

```bash
bundle install
```

2. Run the example:

```bash
bundle exec ruby example/example.rb
```

## Configuration Scopes

The SDK supports three nested configuration scopes. The most-specific scope always wins; changes made at a narrower scope do not persist beyond that scope.

### SDK-level (default)

Set once at initialization and applied to every request unless overridden.

```ruby
require 'celitech'

sdk = Celitech::Client.new(
  base_url: 'https://api.example.com',
  timeout: 30,
)
```

### Service-level

Override config for all requests made through a particular service instance. The original client and other services are not affected.

```ruby
override = Celitech::Config.new(base_url: 'https://api.example.com')
service = sdk.destinations(config: override)
response = service.some_method
```

### Per-request

Override config for a single call only. The next call automatically reverts to the enclosing scope.

```ruby
response = sdk.destinations.some_method(
  config: Celitech::Config.new(base_url: 'https://api.example.com'),
)

# The next call uses the original SDK-level config automatically
response = sdk.destinations.some_method
```

Passing `config: nil` explicitly bypasses any service-level override for that single call, falling back directly to the SDK-level (connection) defaults.

## Authentication

### OAuth Authentication

The Celitech API uses OAuth 2.0 for authentication.

You need to provide your OAuth credentials when initializing the SDK. Tokens are automatically fetched, cached, and refreshed — you do not need to manage them yourself.

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')
```

If you need to set or update the OAuth credentials after the SDK initialization, you can use:

```ruby
require 'celitech'

sdk = Celitech::Client.new

sdk.client_id = 'YOUR_CLIENT_ID'
sdk.client_secret = 'YOUR_CLIENT_SECRET'
```

## Environment Variables

These are the environment variables for the SDK:

| Name          | Description             |
| :------------ | :---------------------- |
| CLIENT_ID     | Client ID parameter     |
| CLIENT_SECRET | Client Secret parameter |

Environment variables are a way to configure your application outside the code. You can set these environment variables on the command line or use your project's existing tooling for managing environment variables.

If you are using a `.env` file, a template with the variable names is provided in the `.env.example` file located in the same directory as this README.

# Sample Usage

Below is a comprehensive example demonstrating how to authenticate and call a simple endpoint:

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.destinations.list_destinations

puts response

```

## Services

The SDK provides various services to interact with the API.

<details>
<summary>Below is a list of all available services with links to their detailed documentation:</summary>

| Name                                                   |
| :----------------------------------------------------- |
| [Destinations](documentation/services/destinations.md) |
| [Packages](documentation/services/packages.md)         |
| [Purchases](documentation/services/purchases.md)       |
| [ESim](documentation/services/e_sim.md)                |
| [IFrame](documentation/services/i_frame.md)            |
| [OAuth](documentation/services/o_auth.md)              |

</details>

## Models

The SDK includes several models that represent the data structures used in API requests and responses. These models help in organizing and managing the data efficiently.

<details>
<summary>Below is a list of all available models with links to their detailed documentation:</summary>

| Name                                                                                             | Description |
| :----------------------------------------------------------------------------------------------- | :---------- |
| [ListDestinationsOkResponse](documentation/models/list_destinations_ok_response.md)              |             |
| [ListPackagesOkResponse](documentation/models/list_packages_ok_response.md)                      |             |
| [CreatePurchaseV2OkResponse](documentation/models/create_purchase_v2_ok_response.md)             |             |
| [CreatePurchaseV2Request](documentation/models/create_purchase_v2_request.md)                    |             |
| [ListPurchasesOkResponse](documentation/models/list_purchases_ok_response.md)                    |             |
| [CreatePurchaseOkResponse](documentation/models/create_purchase_ok_response.md)                  |             |
| [CreatePurchaseRequest](documentation/models/create_purchase_request.md)                         |             |
| [TopUpEsimOkResponse](documentation/models/top_up_esim_ok_response.md)                           |             |
| [TopUpEsimRequest](documentation/models/top_up_esim_request.md)                                  |             |
| [EditPurchaseOkResponse](documentation/models/edit_purchase_ok_response.md)                      |             |
| [EditPurchaseRequest](documentation/models/edit_purchase_request.md)                             |             |
| [GetPurchaseConsumptionOkResponse](documentation/models/get_purchase_consumption_ok_response.md) |             |
| [GetEsimOkResponse](documentation/models/get_esim_ok_response.md)                                |             |
| [GetEsimDeviceOkResponse](documentation/models/get_esim_device_ok_response.md)                   |             |
| [GetEsimHistoryOkResponse](documentation/models/get_esim_history_ok_response.md)                 |             |
| [TokenOkResponse](documentation/models/token_ok_response.md)                                     |             |
| [OAuthTokenResponse](documentation/models/o_auth_token_response.md)                              |             |
| [OAuthTokenRequest](documentation/models/o_auth_token_request.md)                                |             |
| [GrantType](documentation/models/grant_type.md)                                                  |             |
| [BadRequest](documentation/models/bad_request.md)                                                |             |
| [Unauthorized](documentation/models/unauthorized.md)                                             |             |

</details>

## License

This SDK is licensed under the MIT License.

See the [LICENSE](LICENSE) file for more details.
