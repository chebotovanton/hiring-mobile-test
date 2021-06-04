import Foundation

class LivePolicyEventProcessor: PolicyEventProcessor {
    
    private var response: JSONResponse = []
    
    func store(json: JSONResponse) {
        // WIP. Convert JSON response to policies here. Add tests for this coversion?
        self.response = json
    }
    
    func retrieve(for: Date) -> PolicyData {
        let policies = response.map { event in
            Policy(
                id: event.payload.policyId,
                term: PolicyTerm(startDate: Date(), duration: 1),
                vehicle: Vehicle(
                    id: "id",
                    displayVRM: event.payload.vehicle?.prettyVrm ?? "",
                    makeModel: event.payload.vehicle?.make ?? ""))
        }
        return PolicyData(activePolicies: policies, historicVehicles: [])
    }
}
