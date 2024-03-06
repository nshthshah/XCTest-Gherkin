
import Foundation
import XCTest

public struct GherkinStep {
    public private(set) var expression: String
    public private(set) var keyword: String
    public private(set) var file: String
    public private(set) var line: Int
    
    init(_ expression: String, keyword: String, file: String, line: Int) {
        self.expression = expression
        self.keyword = keyword
        self.file = file
        self.line = line
    }
}
