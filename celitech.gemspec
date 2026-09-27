# frozen_string_literal: true

require_relative 'lib/celitech/version'

Gem::Specification.new do |spec|
  spec.name    = 'celitech'
  spec.version = Celitech::VERSION
  spec.authors = ['CELITECH']
  spec.email   = ['support@celitech.com']

  spec.summary = <<~'GEMSPEC_STRING'
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
GEMSPEC_STRING
  spec.homepage = 'https://github.com/Celitech/celitech'
  spec.license = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.3'

  spec.files         = Dir['lib/**/*', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest', '~> 5.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.85.1'
  spec.add_development_dependency 'rubocop-ast', '~> 1.49.1'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.39.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.26.1'
  spec.add_development_dependency 'webmock', '~> 3.19'
end
