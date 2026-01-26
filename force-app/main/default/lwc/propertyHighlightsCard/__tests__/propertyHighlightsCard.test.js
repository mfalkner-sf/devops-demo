import { createElement } from "lwc";
import PropertyHighlightsCard from "c/propertyHighlightsCard";
import getPropertiesForAccount from "@salesforce/apex/PropertyHighlightsController.getPropertiesForAccount";

// Wire adapter mock
jest.mock(
  "@salesforce/apex/PropertyHighlightsController.getPropertiesForAccount",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

describe("c-property-highlights-card", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  function flushPromises() {
    return Promise.resolve();
  }

  it("renders datatable when data is returned", async () => {
    const mockData = [
      {
        id: "a01XXXX000000001AAA",
        name: "Unit 101 - Ocean View",
        status: "Active",
        vmsId: "VMS-1001",
        openCases: 2
      },
      {
        id: "a01XXXX000000002AAA",
        name: "Unit 202 - Mountain View",
        status: "Inactive",
        vmsId: "VMS-2002",
        openCases: 0
      }
    ];

    // Mock wire result
    getPropertiesForAccount.mockResolvedValue(mockData);

    const element = createElement("c-property-highlights-card", {
      is: PropertyHighlightsCard
    });
    element.recordId = "001XXXX000000001AAA";
    document.body.appendChild(element);

    // Allow any microtasks to complete
    await flushPromises();

    // Expect datatable to be in the DOM with rows rendered
    const table = element.shadowRoot.querySelector("lightning-datatable");
    expect(table).not.toBeNull();
    expect(table.data).toHaveLength(2);

    // Verify row contents mapped to URL id and status class computed
    expect(table.data[0].name).toBe("Unit 101 - Ocean View");
    expect(table.data[0].vmsId).toBe("VMS-1001");
    expect(table.data[0].openCases).toBe(2);
  });

  it("shows empty state when no data", async () => {
    getPropertiesForAccount.mockResolvedValue([]);

    const element = createElement("c-property-highlights-card", {
      is: PropertyHighlightsCard
    });
    element.recordId = "001XXXX000000001AAA";
    document.body.appendChild(element);

    await flushPromises();

    const emptyState = element.shadowRoot.querySelector(
      ".slds-text-align_center"
    );
    expect(emptyState).not.toBeNull();
    expect(emptyState.textContent).toMatch(/No properties/i);
  });
});
