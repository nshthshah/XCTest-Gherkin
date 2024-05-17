

import Foundation
import XCTest

extension Notification.Name {
    static var scenarioWillStart: Notification.Name {
        return .init(rawValue: "GherkinScenario.scenarioWillStart")
    }
    static var scenarioDidFail: Notification.Name {
        return .init(rawValue: "GherkinScenario.scenarioDidFail")
    }
    static var scenarioDidFinish: Notification.Name {
        return .init(rawValue: "GherkinScenario.scenarioDidFinish")
    }
    
    static var scenarioStepWillStart: Notification.Name {
        return .init(rawValue: "GherkinScenario.scenarioStepWillStart")
    }
    static var scenarioStepDidFinish: Notification.Name {
        return .init(rawValue: "GherkinScenario.scenarioStepDidFinish")
    }
}

public protocol GherkinScenarioObserver: AnyObject {

    /// Test Case
    func scenarioWillStart(_ testCase: XCTestCase)
    func scenarioDidFail(_ testCase: XCTestCase, didFailWithDescription description: String)
    func scenarioDidFinish(_ testCase: XCTestCase)
    
    /// Test Step
    func scenarioStepWillStart(_ step: GherkinStep)
    func scenarioStepDidFinish(_ step: GherkinStep)
}

extension GherkinScenarioObserver {

    /// Test Case
    func scenarioWillStart(_ testCase: XCTestCase) { }
    func scenarioDidFail(_ testCase: XCTestCase, didFailWithDescription description: String) { }
    func scenarioDidFinish(_ testCase: XCTestCase) { }
    
    /// Test Step
    func scenarioStepWillStart(_ step: GherkinStep) { }
    func scenarioStepDidFinish(_ step: GherkinStep) { }
}
