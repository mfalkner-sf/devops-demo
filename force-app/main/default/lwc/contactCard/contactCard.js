import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class ContactCard extends LightningElement {
  // Hard-coded demo contact data for preview
  contact = {
    name: "Jordan Ellis",
    role: "Property Owner",
    phone: "+1 (303) 555-0199",
    email: "jordan.ellis@example.com",
    avatarUrl: "/resource/IMG_7208",
    yearsAsManager: 7,
    address: {
      street: "123 Aspen Way",
      city: "Steamboat Springs",
      state: "CO",
      postalCode: "80487"
    }
  };

  // Demo property data (Portfolio)
  properties = [
    {
      id: "P-001",
      name: "Aspen Ridge 201",
      vmsId: "VMS-10021",
      openCases: 2,
      ownerContact: "Jordan Ellis"
    },
    {
      id: "P-002",
      name: "Pinecrest 12B",
      vmsId: "VMS-10045",
      openCases: 0,
      ownerContact: "Jordan Ellis"
    },
    {
      id: "P-003",
      name: "Timberline 3C",
      vmsId: "VMS-10098",
      openCases: 1,
      ownerContact: "Jordan Ellis"
    }
  ];

  // Column configuration for lightning-datatable
  columns = [
    { label: "Property Name", fieldName: "name", type: "text" },
    { label: "VMS Number", fieldName: "vmsId", type: "text" },
    { label: "Open Cases", fieldName: "openCases", type: "number" },
    {
      label: "Action",
      type: "button",
      typeAttributes: {
        label: "Contact Owner",
        name: "contact_owner",
        variant: "brand-outline",
        iconName: "utility:email"
      }
    }
  ];

  // Handle row action from datatable (button non-functional by design)
  handleRowAction(event) {
    // Confirm before showing a toast (no server action, demo only)
    const detail = event.detail;
    const actionName = detail.action && detail.action.name;
    if (actionName !== "contact_owner") return;

    const row = detail.row;
    const confirmMessage = `Pretend to contact owner for ${row.name}?`;
    // eslint-disable-next-line no-alert
    const isConfirmed = window.confirm(confirmMessage);
    if (!isConfirmed) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Cancelled",
          message: "No message was sent.",
          variant: "info"
        })
      );
      return;
    }

    // Show success toast (demo)
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Contact Owner",
        message: `A message would be sent to the owner of ${row.name}.`,
        variant: "success"
      })
    );
    // Additionally log to console per guidelines
    // eslint-disable-next-line no-console
    console.log("Contact Owner clicked for property:", row);
  }

  // Wire datatable event handler
  handleDatatableClick(event) {
    // Relay to row action if present
    if (event && event.detail) {
      this.handleRowAction(event);
    }
  }
}
