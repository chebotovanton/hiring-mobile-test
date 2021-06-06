import Foundation

// WIP. Cover this with a protocol?
class Policy: Identifiable, ObservableObject {
    
    let id: String
    private(set) var term: PolicyTerm
    let vehicle: Vehicle
    
    init(id: String, term: PolicyTerm, vehicle: Vehicle) {
        self.id = id
        self.term = term
        self.vehicle = vehicle
    }
    
    // WIP. IS it cool the policy can do it on it's own? Is it better to replace a policy in an array?
    func extend(endDate: Date) {
        // WIP. COver with tests?
        self.term.duration = endDate.timeIntervalSince(endDate)
    }
    
    func cancel() {
        // WIP. COver with tests?
        self.term.duration = 0
    }
}

struct PolicyTerm {
    var startDate: Date
    var duration: TimeInterval
}
