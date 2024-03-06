

import Foundation
import XCTest

extension Notification.Name {
    static var testCaseWillStart: Notification.Name {
        return .init(rawValue: "GherkinScenario.testCaseWillStart")
    }
    static var testCaseDidFail: Notification.Name {
        return .init(rawValue: "GherkinScenario.testCaseDidFail")
    }
    static var testCaseDidFinish: Notification.Name {
        return .init(rawValue: "GherkinScenario.testCaseDidFinish")
    }
    
    static var testStepWillStart: Notification.Name {
        return .init(rawValue: "GherkinScenario.testStepWillStart")
    }
    static var testStepDidFinish: Notification.Name {
        return .init(rawValue: "GherkinScenario.testStepDidFinish")
    }
}

public protocol GherkinScenarioObserver: AnyObject {

    /// Test Case
    func testCaseWillStart(_ testCase: XCTestCase)
    func testCaseDidFail(_ testCase: XCTestCase, didFailWithDescription description: String)
    func testCaseDidFinish(_ testCase: XCTestCase)
    
    /// Test Step
    func testStepWillStart(_ step: GherkinStep)
    func testStepDidFinish(_ step: GherkinStep)
}

extension GherkinScenarioObserver {

    /// Test Case
    func testCaseWillStart(_ testCase: XCTestCase) { }
    func testCaseDidFail(_ testCase: XCTestCase, didFailWithDescription description: String) { }
    func testCaseDidFinish(_ testCase: XCTestCase) { }
    
    /// Test Step
    func testStepWillStart(_ step: GherkinStep) { }
    func testStepDidFinish(_ step: GherkinStep) { }
}
