import Foundation

class LivePolicyEventProcessor: PolicyEventProcessor {
    
    private var policies: [Policy] = []
    
    // WIP. Make it more functional?
    func store(json: JSONResponse) {
        // WIP. Convert JSON response to policies here. Add tests for this coversion?
        var policies: [Policy] = []
        
        // WIP. Sort events by date, so cancel and extension go after the creation?
        for event in json {
            switch event.type {
            // WIP. Move constants to enum
            case "policy_created":
                if let policy = self.createNewPolicy(event: event) {
                    policies.append(policy)
                }
            case "policy_extension":
                self.extendPolicy(policies: policies, event: event)
            case "policy_cancelled":
                self.cancelPolicy(policies: policies, event: event)
            default:
                return
            }
        }
        
        self.policies = policies
    }
    
    private func createNewPolicy(event: JSONEvent) -> Policy? {
        guard let startDate = event.payload.startDate,
              let endDate = event.payload.endDate,
              let vehicle = event.payload.vehicle else {
            return nil
        }
        return Policy(
            id: event.payload.policyId,
            term: PolicyTerm(startDate: startDate, duration: endDate.timeIntervalSince(startDate)),
            vehicle: Vehicle(
                // WIP. WHat's the vehicle id?
                id: "id",
                displayVRM: vehicle.prettyVrm,
                makeModel: vehicle.make
            )
        )
    }

    private func extendPolicy(policies: [Policy], event: JSONEvent) {
        guard let policyToExtend = policies.first(where: { $0.id == event.payload.policyId }),
              let endDate = event.payload.endDate else { return }
        policyToExtend.extend(endDate: endDate)
    }
    
    private func cancelPolicy(policies: [Policy], event: JSONEvent) {
        policies.first(where: { $0.id == event.payload.policyId })?
            .cancel()
    }
    
    func retrieve(for: Date) -> PolicyData {
        // WIP. Process policies by date here
        return PolicyData(activePolicies: self.policies,
                          historicVehicles: [])
    }
}
