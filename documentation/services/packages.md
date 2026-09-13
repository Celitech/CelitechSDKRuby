# Packages

A list of all methods in the `Packages` service. Click on the method name to view detailed information about that method.

| Methods                         | Description   |
| :------------------------------ | :------------ |
| [list_packages](#list_packages) | List Packages |

## list_packages

List Packages

- HTTP Method: `GET`
- Endpoint: `/packages`

**Parameters**

| Name              | Type   | Required | Description                                                                                                                                                                                                                                                                                          |
| :---------------- | :----- | :------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| destination       | String | ❌       | ISO representation of the package's destination. Supports both ISO2 (e.g., 'FR') and ISO3 (e.g., 'FRA') country codes.                                                                                                                                                                               |
| data_limit_in_gb  | String | ❌       | Filter packages by data limit in GB. When provided, only packages with this exact data limit are returned. Use `-1` together with `includeUnlimited=true` to return only unlimited packages. A value of `0` is ignored.                                                                              |
| start_date        | String | ❌       | Start date of the package's validity in the format 'yyyy-MM-dd'. This date can be set to the current day or any day within the next 12 months.                                                                                                                                                       |
| end_date          | String | ❌       | End date of the package's validity in the format 'yyyy-MM-dd'. End date can be maximum 90 days after Start date.                                                                                                                                                                                     |
| after_cursor      | String | ❌       | To get the next batch of results, use this parameter. It tells the API where to start fetching data after the last item you received. It helps you avoid repeats and efficiently browse through large sets of data.                                                                                  |
| limit             | String | ❌       | Maximum number of packages to be returned in the response. The value must be greater than 0 and less than or equal to 160. If not provided, the default value is 20                                                                                                                                  |
| start_time        | String | ❌       | Epoch value representing the start time of the package's validity. This timestamp can be set to the current time or any time within the next 12 months                                                                                                                                               |
| end_time          | String | ❌       | Epoch value representing the end time of the package's validity. End time can be maximum 90 days after Start time                                                                                                                                                                                    |
| include_unlimited | String | ❌       | Whether to include unlimited (date-based) packages in the results. Unlimited packages are excluded by default; set this to `true` to include them. An unlimited package has `dataLimitInGB` and `dataLimitInBytes` equal to `-1`, and is offered for 3 to 30 days with `minDays` equal to `maxDays`. |
| config            | Config | ❌       | Override the client-level config for this single request.                                                                                                                                                                                                                                            |

**Return Type**

`ListPackagesOkResponse`

**Example Usage Code Snippet**

```ruby
require 'celitech'

sdk = Celitech::Client.new(client_id: 'YOUR_CLIENT_ID', client_secret: 'YOUR_CLIENT_SECRET')

response = sdk.packages.list_packages

puts response
```
