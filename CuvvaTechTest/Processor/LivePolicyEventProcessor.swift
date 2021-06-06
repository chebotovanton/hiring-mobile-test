import Foundation

class LivePolicyEventProcessor: PolicyEventProcessor {
    
    private let policyStorage: PolicyStorageProtocol
    
    init(policyStorage: PolicyStorageProtocol) {
        self.policyStorage = policyStorage
    }
    
    func retrieve(for: Date) -> PolicyData {
        // Chebotov. It is possible to get rid of a vehicles array here. I think it will make code harder to understand. And less effective as well, we'll need to create a historic vehicles array from scratch on every request
        let (policies, vehicles) = self.policyStorage.retrieve()
        
        var activePolicies: [Policy] = []
        for policy in policies {
            if `for`.timeIntervalSince(policy.term.startDate) > policy.term.duration {
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
