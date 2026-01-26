**Task**
build a lightning web component named "Contact Card" to be placed on the account record page.

**Requirements**

1. **Context** this is a basic contact card to provide a professional and nice looking card of a contacts image, name, phone number, address, properties owned, years as a property manager.
2. **Functionality**

- Create hard-coded dummy data to fill in the contact card for preview and testing purposes.
- Columns/Fields: Property Name, Status (Badge style), VMS ID, and a calculated "Open Cases" count if available.
- **Action**: Include a "Contact Owner" button next to each property. When clicked, this button will not work for the purpose of this demo.

3. **UI/UX**:
   - Use `lightning-card` container with a custom icon.
   - Use SLDS (Salesforce Lightning Design System) classes to make it look like a "White Glove" hospitality dashboard.
4. **Testing**: Provide a basic Jest test file (`ContactCard.test.js`) that verifies the data table renders when data is returned.
