
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

    @discardableResult
    func scenario(withMetadata metadata: JsonType = JsonType()) -> XCTestCase {
        self.metadata = metadata
        self.steps.removeAll()
        self.state.currentStepDepth = 0
        self.state.currentStepLocation = nil
        return self
    }

    func execute() {
        GherkinScenarioObservationCenter.shared.triggernotification(forState: .scenarioWillStart(self))
        self.steps.forEach { step in
            GherkinScenarioObservationCenter.shared.triggernotification(forState: .scenarioStepWillStart(step))
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
            GherkinScenarioObservationCenter.shared.triggernotification(forState: .scenarioStepDidFinish(step))
        }
        GherkinScenarioObservationCenter.shared.triggernotification(forState: .scenarioDidFinish(self))
    }

    @discardableResult
    func given(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "Given", file: file, line: line)
        self.steps.append(step)
        return self
    }

    @discardableResult
    func when(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "When", file: file, line: line)
        self.steps.append(step)
        return self
    }

    @discardableResult
    func then(_ expression: String, file: String = #file, line: Int = #line) -> XCTestCase {
        let step = GherkinStep(expression, keyword: "Then", file: file, line: line)
        self.steps.append(step)
        return self
    }

    @discardableResult
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
        case scenarioWillStart(XCTestCase)
        case scenarioDidFail(XCTestCase, String)
        case scenarioDidFinish(XCTestCase)
        
        /// Test Step
        case scenarioStepWillStart(GherkinStep)
        case scenarioStepDidFinish(GherkinStep)
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
            case .scenarioStepWillStart(let step):
                observer.scenarioStepWillStart(step)
            case .scenarioStepDidFinish(let step):
                observer.scenarioStepDidFinish(step)
            case .scenarioWillStart(let testcase):
                observer.scenarioWillStart(testcase)
            case .scenarioDidFail(let testcase, let failureDescription):
                observer.scenarioDidFail(testcase, didFailWithDescription: failureDescription)
            case .scenarioDidFinish(let testcase):
                observer.scenarioDidFinish(testcase)
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
