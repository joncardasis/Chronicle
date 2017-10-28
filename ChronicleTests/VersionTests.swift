//
//  VersionTests.swift
//  Chronicle
//
//  Created by Jon on 10/20/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import Chronicle

class VersionTests: XCTestCase {
    
    
    var systemVersion: SystemVersion!
    var oldestVersionAllowed: DetailedVersion!
    var currentVersion: DetailedVersion!
    var nextReleaseVersion: DetailedVersion!
    
    override func setUp() {
        super.setUp()
        
        systemVersion = SystemVersion(version: "1.1.1")
        
        oldestVersionAllowed = DetailedVersion(versionType: .minimum,
                                message: "A neat version",
                                storeUrl: URL(string: "https://www.google.com")!,
                                notificationType: .once,
                                version: "0.0.1")
        
        currentVersion = DetailedVersion(versionType: .recommended,
                                 message: "A neat version",
                                 storeUrl: URL(string: "https://www.google.com")!,
                                 notificationType: .once,
                                 version: "1.2.1")
        
        nextReleaseVersion = DetailedVersion(versionType: .recommended,
                                     message: "A neat version",
                                     storeUrl: URL(string: "https://www.google.com")!,
                                     notificationType: .once,
                                     version: "2.0")
    }
    
    override func tearDown() {
        super.tearDown()
        systemVersion = nil
        oldestVersionAllowed = nil
        currentVersion = nil
        nextReleaseVersion = nil
    }
    
   
    func testSystemVersionLessThanCurrent() {
        XCTAssertTrue(systemVersion < currentVersion)
    }
    
    func testSystemVersionGreaterThanCurrent() {
        XCTAssertFalse(systemVersion > currentVersion)
    }
    
    func testSystemVersionIsCurrent() {
        XCTAssertFalse(systemVersion == currentVersion)
    }
    
    func testVersionsEqual() {
        XCTAssertTrue(currentVersion == currentVersion)
    }
    
    func testForceUpdateIsNeeded() {
        let minVersion = DetailedVersion(versionType: .minimum,
                                         message: "A neat version",
                                         storeUrl: URL(string: "https://www.google.com")!,
                                         notificationType: .once,
                                         version: "1.2.0")
        
        XCTAssertTrue(systemVersion < minVersion)
    }
    
    func testSemanticVersioningTwoVsOneComponents() {
        let oneDigitVersion = SystemVersion(version: "3.400")
        let threeDigitVersion = SystemVersion(version: "2.30.102")
        XCTAssertTrue(oneDigitVersion > threeDigitVersion)
        XCTAssertTrue(threeDigitVersion < oneDigitVersion)
        XCTAssertFalse(oneDigitVersion == threeDigitVersion)
    }
    
    func testSemanticVersioningThreeVsOneComponents() {
        let oneDigitVersion = SystemVersion(version: "3")
        let threeDigitVersion = SystemVersion(version: "2.30.102")
        XCTAssertTrue(oneDigitVersion > threeDigitVersion)
        XCTAssertTrue(threeDigitVersion < oneDigitVersion)
        XCTAssertFalse(oneDigitVersion == threeDigitVersion)
    }
    
    func testSemanticVersioningOneDigitDifference() {
        let lesserVersion = SystemVersion(version: "3.109.10")
        let greaterVersion = SystemVersion(version: "3.110.10")
        XCTAssertTrue(lesserVersion < greaterVersion)
        XCTAssertTrue(greaterVersion > lesserVersion)
    }
    
    
    
}
