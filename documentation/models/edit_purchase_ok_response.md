# EditPurchaseOkResponse

**Properties**

| Name           | Type   | Required | Description                                                                |
| :------------- | :----- | :------- | :------------------------------------------------------------------------- |
| purchase_id    | Object | ✅       | ID of the purchase                                                         |
| new_start_date | Object | ✅       | Start date of the package's validity in the format 'yyyy-MM-ddThh:mm:ssZZ' |
| new_end_date   | Object | ✅       | End date of the package's validity in the format 'yyyy-MM-ddThh:mm:ssZZ'   |
| new_start_time | Object | ❌       | Epoch value representing the new start time of the package's validity      |
| new_end_time   | Object | ❌       | Epoch value representing the new end time of the package's validity        |
