/**
 * @description Service layer class to fetch Household 360 view data for Service Console component
 * @author      Resort Group TA
 * @since       Spring '26
 */
public with sharing class Household360Service {
  /**
   * @description Wrapper class to hold the complete Household 360 data structure
   */
  public class HouseholdData {
    @AuraEnabled
    public AccountInfo account;
    @AuraEnabled
    public ContactInfo contact;
    @AuraEnabled
    public List<PropertyInfo> properties;
    @AuraEnabled
    public List<CaseInfo> cases;

    public HouseholdData() {
      this.properties = new List<PropertyInfo>();
      this.cases = new List<CaseInfo>();
    }
  }

  /**
   * @description Wrapper class for Account information
   */
  public class AccountInfo {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String name;

    public AccountInfo(Id id, String name) {
      this.id = id;
      this.name = name;
    }
  }

  /**
   * @description Wrapper class for Contact information
   */
  public class ContactInfo {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String firstName;
    @AuraEnabled
    public String lastName;
    @AuraEnabled
    public String email;

    public ContactInfo(Id id, String firstName, String lastName, String email) {
      this.id = id;
      this.firstName = firstName;
      this.lastName = lastName;
      this.email = email;
    }
  }

  /**
   * @description Wrapper class for Property information
   */
  public class PropertyInfo {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String externalId;

    public PropertyInfo(Id id, String name, String status, String externalId) {
      this.id = id;
      this.name = name;
      this.status = status;
      this.externalId = externalId;
    }
  }

  /**
   * @description Wrapper class for Case information
   */
  public class CaseInfo {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String subject;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String origin;
    @AuraEnabled
    public DateTime createdDate;

    public CaseInfo(
      Id id,
      String subject,
      String status,
      String origin,
      DateTime createdDate
    ) {
      this.id = id;
      this.subject = subject;
      this.status = status;
      this.origin = origin;
      this.createdDate = createdDate;
    }
  }

  /**
   * @description Main method to fetch Household 360 data for an Account
   * @param accountId The Id of the Household/LLC Account
   * @return HouseholdData object containing all requested information
   */
  @AuraEnabled(cacheable=true)
  public static HouseholdData getHousehold360Data(Id accountId) {
    HouseholdData result = new HouseholdData();

    // Validate input
    if (accountId == null) {
      return result;
    }

    try {
      // Query Account with primary Contact and related Properties and Cases
      List<Account> accounts = [
        SELECT
          Id,
          Name,
          (SELECT Id, FirstName, LastName, Email FROM Contacts),
          (SELECT Id, Name, Status__c, VMS_Id__c FROM Properties__r),
          (
            SELECT Id, Subject, Status, Origin, CreatedDate
            FROM Cases
            ORDER BY CreatedDate DESC
            LIMIT 5
          )
        FROM Account
        WHERE Id = :accountId
        WITH SECURITY_ENFORCED
      ];

      if (accounts.isEmpty()) {
        return result;
      }

      Account acc = accounts[0];

      // Set Account info
      result.account = new AccountInfo(acc.Id, acc.Name);

      // Set Contact info (assuming primary contact is the first one)
      if (acc.Contacts != null && !acc.Contacts.isEmpty()) {
        Contact primaryContact = acc.Contacts[0];
        result.contact = new ContactInfo(
          primaryContact.Id,
          primaryContact.FirstName,
          primaryContact.LastName,
          primaryContact.Email
        );
      }

      // Set Property info
      if (acc.Properties__r != null) {
        for (Property__c prop : acc.Properties__r) {
          result.properties.add(
            new PropertyInfo(prop.Id, prop.Name, prop.Status__c, prop.VMS_Id__c)
          );
        }
      }

      // Set Case info
      if (acc.Cases != null) {
        for (Case c : acc.Cases) {
          result.cases.add(
            new CaseInfo(c.Id, c.Subject, c.Status, c.Origin, c.CreatedDate)
          );
        }
      }
    } catch (Exception e) {
      // Log error and return empty result
      System.debug('Error fetching Household 360 data: ' + e.getMessage());
    }

    return result;
  }

  /**
   * @description Test method to create dummy data and execute the query
   * This method can be run in Anonymous Apex to verify functionality
   */
  public static void testQuery() {
    // Create test Account
    Account testAccount = new Account(
      Name = 'Test Household Account',
      Type = 'Customer'
    );
    insert testAccount;

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
    for (Integer i = 0; i < 7; i++) {
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

    // Execute the main method
    HouseholdData data = getHousehold360Data(testAccount.Id);

    // Display results for debugging
    System.debug('=== Household 360 Data ===');
    System.debug('Account Name: ' + data.account.name);

    if (data.contact != null) {
      System.debug(
        'Primary Contact: ' +
          data.contact.firstName +
          ' ' +
          data.contact.lastName
      );
    }

    System.debug('Number of Properties: ' + data.properties.size());
    for (PropertyInfo prop : data.properties) {
      System.debug('Property: ' + prop.name + ' - Status: ' + prop.status);
    }

    System.debug('Number of Cases: ' + data.cases.size());
    for (CaseInfo c : data.cases) {
      System.debug('Case: ' + c.subject + ' - Status: ' + c.status);
    }

    // Cleanup (optional - remove if you want to keep test data)
    // delete testCases;
    // delete testProperties;
    // delete testAccount;
  }
}
