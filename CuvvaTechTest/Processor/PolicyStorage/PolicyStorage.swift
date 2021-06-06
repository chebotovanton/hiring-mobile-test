//
//  PolicyStorage.swift
//  CuvvaTechTest
//
//  Created by Anton on 06/06/2021.
//

import Foundation

protocol PolicyStorageProtocol {
    func store(json: JSONResponse)
    func retrieve() -> (policies: [Policy], vehicles: [Vehicle])
}
// WIP. Cover this with tests
class PolicyStorage: PolicyStorageProtocol {
    private var policies: [Policy] = []
    private var vehicles: [Vehicle] = []
    
    private let policyUpdater: PolicyUpdaterProtocol
    
    init(policyUpdater: PolicyUpdaterProtocol) {
        self.policyUpdater = policyUpdater
    }
    
    func store(json: JSONResponse) {
        var policies: [Policy] = []
        var vehicles: [Vehicle] = []
        
        // WIP. Is it possible to avoid sorting?
        json.sorted(by: { $0.payload.timestamp > $1.payload.timestamp })
            .forEach { event in
            switch event.type {
            case .created:
                if let policy = self.policyUpdater.createNewPolicy(event: event, vehicles: &vehicles) {
                    policies.append(policy)
                }
            case .extended:
                self.policyUpdater.extendPolicy(policies: &policies, event: event)
            case .cancelled:
                self.policyUpdater.cancelPolicy(policies: &policies, event: event)
            default:
                return
            }
        }
        self.policies = policies
        self.vehicles = vehicles
    }
    func retrieve() -> (policies: [Policy], vehicles: [Vehicle]) {
        return (self.policies, self.vehicles)
    }
}

class MockPolicyStorage: PolicyStorageProtocol {
    func store(json: JSONResponse) { }
    
    func retrieve() -> (policies: [Policy], vehicles: [Vehicle]) {
        return ([], [])
    }
}
