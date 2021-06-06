import Foundation

class LivePolicyEventProcessor: PolicyEventProcessor {
    
    private var policies: [Policy] = []
    private var vehicles: [Vehicle] = []
    
    // WIP. Make it more functional?
    func store(json: JSONResponse) {
        // WIP. Add tests for this conversion? Need to find out the requirements first
        var policies: [Policy] = []
        var vehicles: [Vehicle] = []
        
        json.sorted(by: { $0.payload.timestamp > $1.payload.timestamp })
            .forEach { event in
            switch event.type {
            case .created:
                if let policy = self.createNewPolicy(event: event, vehicles: &vehicles) {
                    policies.append(policy)
                }
            case .extended:
                self.extendPolicy(policies: policies, event: event)
            case .cancelled:
                self.cancelPolicy(policies: policies, event: event)
            default:
                return
            }
        }
        self.policies = policies
        self.vehicles = vehicles
    }
    
    private func createNewPolicy(event: JSONEvent, vehicles: inout [Vehicle]) -> Policy? {
        guard let startDate = event.payload.startDate,
              let endDate = event.payload.endDate,
              let jsonVehicle = event.payload.vehicle else {
            return nil
        }
        let vehicleId = jsonVehicle.make + jsonVehicle.model + jsonVehicle.prettyVrm
        
        let vehicle: Vehicle
        if let existingVehicle = vehicles.first(where: { $0.id == vehicleId }) {
            vehicle = existingVehicle
        } else {
            vehicle = Vehicle(
                // WIP. WHat's the vehicle id?
                id: vehicleId,
                displayVRM: jsonVehicle.prettyVrm,
                makeModel: jsonVehicle.make
            )
            vehicles.append(vehicle)
        }

        return Policy(
            id: event.payload.policyId,
            term: PolicyTerm(startDate: startDate, duration: endDate.timeIntervalSince(startDate)),
            vehicle: vehicle
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
        var activePolicies: [Policy] = []
        for policy in self.policies {
            // WIP. remove 3600 'fix'
            if `for`.timeIntervalSince(policy.term.startDate) > policy.term.duration + 3600 {
                policy.vehicle.historicalPolicies.append(policy)
            } else {
                policy.vehicle.activePolicy = policy
                activePolicies.append(policy)
            }
        }
        
        let historicVehicle = vehicles.filter { $0.activePolicy == nil }
        
        return PolicyData(activePolicies: activePolicies,
                          historicVehicles: historicVehicle)
    }
}
