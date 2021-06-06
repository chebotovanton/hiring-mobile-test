import Foundation

struct LivePolicyTermFormatter: PolicyTermFormatter {
    private let dateFormatter: DateFormatter
    private let dateComponentsFormatter: DateComponentsFormatter
    
    init() {
        // WIP. Inject these formatters?
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .medium
        
        self.dateComponentsFormatter = DateComponentsFormatter()
        self.dateComponentsFormatter.allowedUnits = [.month, .weekOfMonth, .day, .hour, .minute, .second]
        self.dateComponentsFormatter.collapsesLargestUnit = true
        self.dateComponentsFormatter.maximumUnitCount = 1
        self.dateComponentsFormatter.unitsStyle = .full
    }
    
    func durationString(for: TimeInterval) -> String {
        // WIP. Transform 60 minutes to 1 hour
        guard let resultString = self.dateComponentsFormatter.string(from: `for`) else {
            return "Duration unknown"
        }
        return resultString + " Policy"
    }
    
    // WIP. All the policies are expired
    func durationRemainingString(for: PolicyTerm, relativeTo: Date) -> String {
        let duration = `for`.duration
        let passedTime = relativeTo.timeIntervalSince(`for`.startDate)
        let remainingTime = duration - passedTime
        return self.dateComponentsFormatter.string(from: remainingTime) ?? "Unknown time left"
    }
    
    func durationRemainingPercent(for: PolicyTerm, relativeTo: Date) -> Double {
        let progress = Double(relativeTo.timeIntervalSince(`for`.startDate)) / Double(`for`.duration)
        return min(max(progress, 0), 1)
    }
    
    // WIP. How to see this in the app?
    func policyDateString(for: Date) -> String {
//        "Mon, 9th Jan 2007 at 9:41am"
        return self.dateFormatter.string(from: `for`)
    }
}

