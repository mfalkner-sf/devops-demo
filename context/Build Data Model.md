**Task**
Generate the SFDX metadata (XML or valid Apex/Schema builder script) to create the `Property__c` custom object.

**Requirements**

1. **Object Details**: `Property__c` (Label: Property, Plural: Properties).
2. **Fields**:
   - `Property_Name__c` (Text, 80): Name of the unit (e.g., "Trappers Crossing Unit 402").
   - `Rental_Status__c` (Picklist): Values: "Rental Program", "HOA Only", "Long Term Lease", "Maintenance Hold".
   - `VMS_Account_ID__c` (Text, External ID, Unique): To store the legacy key from the HOA accounting system.
   - `Track_Unit_ID__c` (Text, External ID, Unique): To store the legacy key from the Rental PMS.
   - `Household__c` (Master-Detail to Account): Links the property to the Owner/LLC.
   - `Last_Inspection_Date__c` (Date): To track operational readiness.
3. **Standards**:
   - Include `description` tags on all fields explaining they are for "Phase 1 Data Aggregation" from VMS/Track.
   - Ensure the object is set to `Deployed` status.
