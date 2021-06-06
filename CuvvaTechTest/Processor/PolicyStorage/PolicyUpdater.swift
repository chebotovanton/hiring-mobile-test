//
//  PolicyUpdater.swift
//  CuvvaTechTest
//
//  Created by Anton on 06/06/2021.
//

import Foundation

protocol PolicyUpdaterProtocol {
    func createNewPolicy(event: JSONEvent, vehicles: inout [Vehicle]) -> Policy?
    func extendPolicy(policies: inout [Policy], event: JSONEvent)
    func cancelPolicy(policies: inout [Policy], event: JSONEvent)
}

// WIP. Cover with tests
final class PolicyUpdater: PolicyUpdaterProtocol {
    func createNewPolicy(event: JSONEvent, vehicles: inout [Vehicle]) -> Policy? {
        guard let startDate = event.payload.startDate,
              let endDate = event.payload.endDate,
              let jsonVehicle = event.payload.vehicle else {
            return nil
        }
        let vehicleId = self.generateId(for: jsonVehicle)
        
        let vehicle: Vehicle
        if let existingVehicle = vehicles.first(where: { $0.id == vehicleId }) {
            vehicle = existingVehicle
        } else {
            vehicle = Vehicle(
                id: vehicleId,
                displayVRM: jsonVehicle.prettyVrm,
                makeModel: "\(jsonVehicle.make) \(jsonVehicle.model)"
            )
            vehicles.append(vehicle)
        }

        return Policy(
            id: event.payload.policyId,
            term: PolicyTerm(startDate: startDate, duration: endDate.timeIntervalSince(startDate)),
            vehicle: vehicle
        )
    }
    // WIP. Move extend and cancel to a new class?
    func extendPolicy(policies: inout [Policy], event: JSONEvent) {
        guard let policyToExtendIndex = policies.firstIndex(where: { $0.id == event.payload.policyId }),
              let endDate = event.payload.endDate else { return }
        let policyToExtend = policies[policyToExtendIndex]
        var newTerm = policyToExtend.term
        newTerm.duration = endDate.timeIntervalSince(newTerm.startDate)
        let extendedPolicy = Policy(
            id: policyToExtend.id,
            term: newTerm,
            vehicle: policyToExtend.vehicle)
        policies[policyToExtendIndex] = extendedPolicy
    }
    
    func cancelPolicy(policies: inout [Policy], event: JSONEvent) {
        guard let policyToCancelIndex = policies.firstIndex(where: { $0.id == event.payload.policyId }) else { return }
        let policyToExtend = policies[policyToCancelIndex]
        var newTerm = policyToExtend.term
        newTerm.duration = 0
        let cancelledPolicy = Policy(
            id: policyToExtend.id,
            term: newTerm,
            vehicle: policyToExtend.vehicle)
        policies[policyToCancelIndex] = cancelledPolicy
    }
    
    private func generateId(for vehicle: JSONVehicle) -> String {
        // Chebotov. It would be nice to get an id from the server
        return vehicle.make + vehicle.model + vehicle.prettyVrm
    }
}
