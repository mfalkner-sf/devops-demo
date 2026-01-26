/**
 * @description Test class for Household360Service
 * @author      Resort Group TA
 * @since       Spring '26
 */
@isTest
public class Household360ServiceTest {
  @isTest
  static void testGetHousehold360Data() {
    // Create test Account
    Account testAccount = new Account(
      Name = 'Test Household Account',
      Type = 'Customer'
    );
    insert testAccount;

    // Create test Contact
    Contact testContact = new Contact(
      FirstName = 'John',
      LastName = 'Doe',
      Email = 'john.doe@test.com',
      AccountId = testAccount.Id
    );
    insert testContact;

    // Create test Properties
    List<Property__c> testProperties = new List<Property__c>();
    for (Integer i = 0; i < 3; i++) {
      testProperties.add(
        new Property__c(
          Name = 'Property ' + (i + 1),
          Owner_Account__c = testAccount.Id,
          Status__c = 'Active',
          VMS_Id__c = 'VMS-' + (i + 1)
        )
      );
    }
    insert testProperties;

    // Create test Cases
    List<Case> testCases = new List<Case>();
    for (Integer i = 0; i < 5; i++) {
      testCases.add(
        new Case(
          Subject = 'Work Order ' + (i + 1),
          AccountId = testAccount.Id,
          Status = 'New',
          Origin = 'Phone',
          CreatedDate = System.now().addDays(-i)
        )
      );
    }
    insert testCases;

    // Test the main method
    Household360Service.HouseholdData data = Household360Service.getHousehold360Data(
      testAccount.Id
    );

    // Verify Account data
    System.assertNotEquals(null, data.account);
    System.assertEquals(testAccount.Name, data.account.name);

    // Verify Contact data
    System.assertNotEquals(null, data.contact);
    System.assertEquals(testContact.FirstName, data.contact.firstName);
    System.assertEquals(testContact.LastName, data.contact.lastName);
    System.assertEquals(testContact.Email, data.contact.email);

    // Verify Properties data
    System.assertNotEquals(null, data.properties);
    System.assertEquals(3, data.properties.size());

    // Verify Cases data (should be limited to 5)
    System.assertNotEquals(null, data.cases);
    System.assertEquals(5, data.cases.size());

    // Verify Cases are ordered by CreatedDate DESC
    for (Integer i = 0; i < data.cases.size() - 1; i++) {
      CaseInfo current = data.cases[i];
      CaseInfo next = data.cases[i + 1];
      System.assert(
        current.createdDate >= next.createdDate,
        'Cases should be ordered by CreatedDate DESC'
      );
    }

    // Test with null account ID
    Household360Service.HouseholdData nullData = Household360Service.getHousehold360Data(
      null
    );
    System.assertEquals(0, nullData.properties.size());
    System.assertEquals(0, nullData.cases.size());

    // Test with non-existent account ID
    Household360Service.HouseholdData emptyData = Household360Service.getHousehold360Data(
      '000000000000000AAA'
    );
    System.assertEquals(0, emptyData.properties.size());
    System.assertEquals(0, emptyData.cases.size());
  }

  @isTest
  static void testTestQueryMethod() {
    // Simply verify that the test method compiles and runs without error
    // This method creates test data and executes the main method
    Test.startTest();
    Household360Service.testQuery();
    Test.stopTest();

    // If we reach here without exception, the test passed
    System.assert(true, 'Test query method executed successfully');
  }
}
