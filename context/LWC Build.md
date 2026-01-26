**Task**
Build a Lightning Web Component named `propertyHighlightsCard` to be placed on the Account Record Page.

**Requirements**

1. **Context**: This component gives the Reservation/HOA Manager an immediate view of the properties owned by this Household.
2. **Functionality**:
   - Uses the `@wire` service to fetch the data defined in the previous SOQL step.
   - Displays a **lightning-datatable** or a responsive Grid of "Property Cards."
   - Columns/Fields: Property Name, Status (Badge style), VMS ID, and a calculated "Open Cases" count if available.
   - **Action**: Include a "New Work Order" button next to each property. When clicked, it should dispatch a `lightning/navigation` event to open a standard flow named `Create_Breezeway_Work_Order`.
3. **UI/UX**:
   - Use `lightning-card` container with a custom icon.
   - Use SLDS (Salesforce Lightning Design System) classes to make it look like a "White Glove" hospitality dashboard.
4. **Testing**: Provide a basic Jest test file (`propertyHighlightsCard.test.js`) that verifies the data table renders when data is returned.
