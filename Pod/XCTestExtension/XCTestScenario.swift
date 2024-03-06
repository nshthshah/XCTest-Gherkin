
import Foundation
import XCTest

public typealias JsonType = [String: AnyObject]

public extension XCTestCase {
    
    private static var _steps: [GherkinStep]?
    private static var _metadata: JsonType?

    private var steps: [GherkinStep] {
        get { return XCTestCase._steps ?? [] }
        set(steps) { XCTestCase._steps = steps }
    }
    
    var metadata: JsonType {
        get { return XCTestCase._metadata ?? JsonType() }
        set(metadata) { XCTestCase._metadata = metadata }
    }
    
    func scenario(withMetadata metadata: JsonType = JsonType()) -> XCTestCase {
        self.metadata = metadata
        self.steps.removeAll()
        self.state.currentStepDepth = 0
        self.state.currentStepLocation = nil
        return self
    }
    
    func execute() {
        self.steps.forEach { step in
            GherkinScenarioObservationCenter.shared.triggernotification(forState: .testStepWillStart(step))
            switch step.keyword.lowercased() {
            case "given":
                self.Given(step.expression, file: step.file, line: step.line)
            case "when":
                self.When(step.expression, file: step.file, line: step.line)
            case "then":
                self.Then(step.expression, file: step.file, line: step.line)
            case "and":
                self.And(step.expression, file: step.file, line: step.line)
            default:
                self.When(step.expression, file: step.file, line: step.line)
            }
            GherkinScenarioObservationCenter.shared.triggernotification(forState: .testStepDidFinish(step))
        }
    }
    
    func given(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "Given", file: file, line: line)
        self.steps.append(step)
        return self
    }
    
    func when(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "When", file: file, line: line)
        self.steps.append(step)
        return self
    }
    
    func then(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "Then", file: file, line: line)
        self.steps.append(step)
        return self
    }
    
    func and(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "And", file: file, line: line)
        self.steps.append(step)
        return self
    }
}

/// GherkinScenario

public class GherkinScenarioObservationCenter {
    public static let shared = GherkinScenarioObservationCenter()
    private let notificationCenter: NotificationCenter
    private var observations = [ObjectIdentifier : Observation]()

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
}

internal extension GherkinScenarioObservationCenter {
    enum State {
        case testCaseWillStart(XCTestCase)
        case testCaseDidFail(XCTestCase, String)
        case testCaseDidFinish(XCTestCase)
        
        /// Test Step
        case testStepWillStart(GherkinStep)
        case testStepDidFinish(GherkinStep)
    }
}

fileprivate extension GherkinScenarioObservationCenter {
    struct Observation {
        var observer: GherkinScenarioObserver?
    }
}

internal extension GherkinScenarioObservationCenter {
    func triggernotification(forState state: State) {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            switch state {
            case .testStepWillStart(let step):
                observer.testStepWillStart(step)
            case .testStepDidFinish(let step):
                observer.testStepDidFinish(step)
            case .testCaseWillStart(let testcase):
                observer.testCaseWillStart(testcase)
            case .testCaseDidFail(let testcase, let failureDescription):
                observer.testCaseDidFail(testcase, didFailWithDescription: failureDescription)
            case .testCaseDidFinish(let testcase):
                observer.testCaseDidFinish(testcase)
            }
        }
    }
}

public extension GherkinScenarioObservationCenter {
    func addObserver(_ observer: GherkinScenarioObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: GherkinScenarioObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
