import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getPropertiesForAccount from "@salesforce/apex/PropertyHighlightsController.getPropertiesForAccount";

const COLUMNS = [
  {
    label: "Property Name",
    fieldName: "id",
    type: "url",
    sortable: false,
    typeAttributes: {
      label: { fieldName: "name" },
      target: "_blank"
    }
  },
  { label: "VMS Number", fieldName: "vmsId", type: "text" },
  { label: "Open Cases", fieldName: "openCases", type: "number" },
  {
    type: "action",
    typeAttributes: {
      rowActions: [{ label: "New Work Order", name: "new_work_order" }]
    }
  }
];

export default class PropertyHighlightsCard extends NavigationMixin(
  LightningElement
) {
  @api recordId;

  // Toggle to populate the table with dummy data for preview/testing
  @api useMockData = false;

  columns = COLUMNS;
  rows = [];
  error;
  loading = true;

  connectedCallback() {
    // If mock mode is enabled or not on a record page, show sample data immediately
    if (this.useMockData || !this.recordId) {
      this.rows = this.buildMockRows();
      this.error = undefined;
      this.loading = false;
    }
  }

  @wire(getPropertiesForAccount, { accountId: "$recordId" })
  wiredProps({ data, error }) {
    // If using mock data, keep showing it and skip processing wire results
    if (this.useMockData || !this.recordId) {
      this.loading = false;
      return;
    }

    this.loading = false;
    if (data) {
      // Decorate with URL and status class for SLDS badge-like styling in table
      this.rows = data.map((r) => ({
        ...r,
        id: "/" + r.id,
        statusClass: this.computeStatusClass(r.status)
      }));
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.rows = [];
    }
  }

  get hasData() {
    return Array.isArray(this.rows) && this.rows.length > 0;
  }

  computeStatusClass(status) {
    if (!status) return "slds-text-color_weak";
    const normalized = String(status).toLowerCase();
    if (normalized.includes("active")) return "slds-badge slds-theme_success";
    // For 'hold' specifically, use custom hex color via CSS class
    if (normalized.includes("hold")) return "slds-badge badge--on-hold";
    if (normalized.includes("maint")) return "slds-badge slds-theme_info";
    if (normalized.includes("inactive") || normalized.includes("off"))
      return "slds-badge";
    return "slds-badge";
  }

  handleRowAction(event) {
    const actionName = event.detail.action && event.detail.action.name;
    const row = event.detail.row;
    if (actionName === "new_work_order" && row) {
      // Row.id is a URL in the table; original Id is derivable by removing leading '/'
      const propertyId = (row.id || "").replace("/", "");

      // In mock mode, prevent navigation and just log a no-op to avoid runtime errors
      if (this.useMockData || !this.recordId) {
        // eslint-disable-next-line no-console
        console.log(
          "Mock mode: would navigate to flow with propertyId:",
          propertyId
        );
        return;
      }

      this.navigateToWorkOrderFlow(propertyId);
    }
  }

  navigateToWorkOrderFlow(propertyId) {
    // Navigate to standard flow with state param propertyId (Flow must have input variable "propertyId")
    this[NavigationMixin.Navigate]({
      type: "standard__flow",
      attributes: {
        flowApiName: "Create_Breezeway_Work_Order"
      },
      state: {
        propertyId: propertyId
      }
    });
  }

  buildMockRows() {
    const sample = [
      {
        id: "a0P000000000001AAA",
        name: "Sunset Villas",
        status: "Active",
        vmsId: "VMS-1001",
        openCases: 3
      },
      {
        id: "a0P000000000002AAA",
        name: "Mountain Retreat",
        status: "Maintenance",
        vmsId: "VMS-1002",
        openCases: 0
      },
      {
        id: "a0P000000000003AAA",
        name: "Oceanview Condos",
        status: "On Hold",
        vmsId: "VMS-1003",
        openCases: 1
      },
      {
        id: "a0P000000000004AAA",
        name: "City Center Loft",
        status: "Inactive",
        vmsId: "VMS-1004",
        openCases: 5
      }
    ];

    return sample.map((r) => ({
      ...r,
      id: "/" + r.id,
      statusClass: this.computeStatusClass(r.status)
    }));
  }
}
