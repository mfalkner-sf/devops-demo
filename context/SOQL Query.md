**Task**
Write a robust SOQL query and a service layer Apex method to fetch the "Household 360" view for a Service Console component.

**Requirements**

1. **Input**: `accountId` (Id of the Household/LLC).
2. **Functionality**:
   - Fetch the Account Name and primary Contact details.
   - **Sub-Query 1**: Fetch all related `Property__c` records (include Name, Status, and External IDs).
   - **Sub-Query 2**: Fetch the 5 most recent `Case` records (Work Orders) associated with the Account, ordered by `CreatedDate DESC`. Include the `Subject`, `Status`, and `Origin`.
3. **Standards**:
   - Optimize for heap size (select only necessary fields).
   - Ensure the query handles Accounts with multiple properties (e.g., an owner with 3 rental units).
4. **Testing**: Provide a `public static void testQuery()` snippet that creates dummy data (Account, Property, Case) and executes the query to debug the results.
