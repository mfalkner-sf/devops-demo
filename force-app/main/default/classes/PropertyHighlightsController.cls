/**
 * @description       Property Highlights data provider for LWC propertyHighlightsCard
 * @group             Owner 360
 * @author            Resort Group TA
 * @since             Spring '26
 *
 * With sharing to respect org sharing. Uses cacheable wire method.
 * Queries Property__c related to Account and aggregates open Case counts by Property__c.
 */
public with sharing class PropertyHighlightsController {
  /**
   * @description Wrapper DTO for property highlight row
   */
  public class PropertyRow {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String vmsId;
    @AuraEnabled
    public Integer openCases;

    public PropertyRow(
      Id id,
      String name,
      String status,
      String vmsId,
      Integer openCases
    ) {
      this.id = id;
      this.name = name;
      this.status = status;
      this.vmsId = vmsId;
      this.openCases = openCases;
    }
  }

  /**
   * @description Returns properties for an Account with open case counts
   * @param accountId The Account Id (from record page)
   */
  @AuraEnabled(cacheable=true)
  public static List<PropertyRow> getPropertiesForAccount(Id accountId) {
    if (accountId == null) {
      // Return early per guidelines
      return new List<PropertyRow>();
    }

    // Query properties related to the Account
    // Assumed field mapping:
    // - Property__c.Owner_Account__c (Lookup(Account))
    // - Property__c.Status__c (Text/Picklist)
    // - Property__c.VMS_Id__c (Text)
    List<Property__c> props = [
      SELECT Id, Name, Status__c, VMS_Id__c
      FROM Property__c
      WHERE Owner_Account__c = :accountId
      WITH SECURITY_ENFORCED
      LIMIT 500
    ];

    if (props.isEmpty()) {
      return new List<PropertyRow>();
    }

    Set<Id> propIds = new Set<Id>();
    for (Property__c p : props) {
      propIds.add(p.Id);
    }

    // Aggregate open cases (IsClosed = false) grouped by Property__c
    Map<Id, Integer> openByProp = new Map<Id, Integer>();
    for (AggregateResult ar : [
      SELECT Property__c propId, COUNT(Id) cnt
      FROM Case
      WHERE Property__c IN :propIds AND IsClosed = FALSE
      GROUP BY Property__c
    ]) {
      openByProp.put((Id) ar.get('propId'), (Integer) ar.get('cnt'));
    }

    List<PropertyRow> results = new List<PropertyRow>();
    for (Property__c p : props) {
      Integer oc = openByProp.get(p.Id);
      results.add(
        new PropertyRow(
          p.Id,
          p.Name,
          (String) p.get('Status__c'),
          (String) p.get('VMS_Id__c'),
          oc == null ? 0 : oc
        )
      );
    }
    return results;
  }
}
