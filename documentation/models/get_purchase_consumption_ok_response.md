# GetPurchaseConsumptionOkResponse

**Properties**

| Name                          | Type   | Required | Description                                                                     |
| :---------------------------- | :----- | :------- | :------------------------------------------------------------------------------ |
| data_usage_remaining_in_bytes | Object | ✅       | Remaining balance of the package in bytes. Returns `-1` for unlimited packages. |
| data_usage_remaining_in_gb    | Object | ✅       | Remaining balance of the package in GB. Returns `-1` for unlimited packages.    |
| status                        | Object | ✅       | Status of the connectivity, possible values are 'ACTIVE' or 'NOT_ACTIVE'        |
