
import Foundation
import XCTest

internal class ClickOnButton: StepDefiner {

    /// User clicks "login" button of Login Screen
    /// I click "login" button of Login Screen
    /// clicks "login" button of Login Screen
    /// clicks "login" button
    static var stepsFormat = "^(I click|User clicks|clicks) \"(?<button>(.*))\" button(?: of %@)?$"

    override func defineSteps() {
        allSubclassesOf(PageObject.self).forEach { (subclass) in
            guard subclass != PageObject.self else { return }

            let name = subclass.name
            let expression = String(format: ClickOnButton.stepsFormat, name)
            step(expression) { (match: StepMatches<String>) in
                let value = match["button"] ?? ""
                subclass.init().app().buttons[value].firstMatch.tap()
            }
        }
    }
}

internal class ClickAny: StepDefiner {

    /// User clicks "login" view of Login Screen
    /// I click "login" view of Login Screen
    /// clicks "login" view of Login Screen
    /// clicks "login" view
    static var stepsFormat = "^(I click|User clicks|clicks) \"(?<any>(.*))\" view(?: of %@)?$"

    override func defineSteps() {
        allSubclassesOf(PageObject.self).forEach { (subclass) in
            guard subclass != PageObject.self else { return }

            let name = subclass.name
            let expression = String(format: ClickAny.stepsFormat, name)
            step(expression) { (match: StepMatches<String>) in
                let value = match["any"] ?? ""
                subclass.init().app().descendants(matching: .any).matching(identifier: value).firstMatch.tap()
            }
        }
    }
}
