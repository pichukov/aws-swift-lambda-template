import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(db_update_lambdaTests.allTests),
    ]
}
#endif
