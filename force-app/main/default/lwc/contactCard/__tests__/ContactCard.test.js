import { createElement } from "lwc";
import ContactCard from "c/contactCard";

describe("c-contact-card", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("renders the contact card with properties table", () => {
    const element = createElement("c-contact-card", {
      is: ContactCard
    });
    document.body.appendChild(element);

    // Verify the component renders
    expect(element).toBeTruthy();

    // Verify the lightning-datatable is rendered
    const datatable = element.shadowRoot.querySelector("lightning-datatable");
    expect(datatable).not.toBeNull();
    expect(datatable.data).toHaveLength(3);
    expect(datatable.columns).toHaveLength(4);
  });

  it("renders correct number of rows in the table", () => {
    const element = createElement("c-contact-card", {
      is: ContactCard
    });
    document.body.appendChild(element);

    const datatable = element.shadowRoot.querySelector("lightning-datatable");
    expect(datatable.data).toHaveLength(3);
  });

  it("renders correct columns in the table", () => {
    const element = createElement("c-contact-card", {
      is: ContactCard
    });
    document.body.appendChild(element);

    const datatable = element.shadowRoot.querySelector("lightning-datatable");
    const expectedColumns = ["Property Name", "VMS Number", "Open Cases", "Action"];
    const actualColumns = datatable.columns.map((col) => col.label);
    expect(actualColumns).toEqual(expectedColumns);
  });

  it("shows properties data when available", () => {
    const element = createElement("c-contact-card", {
      is: ContactCard
    });
    document.body.appendChild(element);

    const datatable = element.shadowRoot.querySelector("lightning-datatable");
    expect(datatable.data).toHaveLength(3);
    expect(datatable.data[0].name).toBe("Aspen Ridge 201");
    expect(datatable.data[2].openCases).toBe(1);
  });
});
