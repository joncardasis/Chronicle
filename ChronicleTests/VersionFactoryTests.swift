//
//  VersionFactoryTests.swift
//  Chronicle
//
//  Created by Jon on 10/20/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import Chronicle

class VersionFactoryTests: XCTestCase {
    
    let jsonDirectory = Bundle(for: VersionFactoryTests.self).resourceURL!.appendingPathComponent("JSON", isDirectory: true)
    
    func testDataParsingFromAllFieldsJson() {
        let factory = validFactoryFromAllFieldsJSON()
        
        let minVersion = factory.minimumVersion!
        let recommendedVersion = factory.recommendedVersion!
        
        // Ensure minVersion parsed correctly
        XCTAssertTrue(minVersion.notificationType == .always)
        XCTAssertTrue(minVersion.version == "1.10.9")
        XCTAssertFalse(minVersion.storeUrl.absoluteString.isEmpty)
        XCTAssertFalse(minVersion.message.isEmpty)
        
        // Ensure recommended parsed correctly
        XCTAssertTrue(recommendedVersion.notificationType == .once)
        XCTAssertTrue(recommendedVersion.version == "1.22.1")
        XCTAssertFalse(recommendedVersion.storeUrl.absoluteString.isEmpty)
        XCTAssertFalse(recommendedVersion.message.isEmpty)
    }
    
    func testDataParsingFromMinFieldsJson() {
        let factory = validFactoryFromMinFieldsJSON()
        
        let minVersion = factory.minimumVersion!
        let recommendedVersion = factory.recommendedVersion
        
        // Recommended version should not have been created
        XCTAssertTrue(recommendedVersion == nil)
        
        // Ensure minVersion parsed correctly
        XCTAssertTrue(minVersion.notificationType == .once)
        XCTAssertTrue(minVersion.version == "1.10.9")
        XCTAssertFalse(minVersion.storeUrl.absoluteString.isEmpty)
        XCTAssertFalse(minVersion.message.isEmpty)
    }
    
    func testNoDataGivenToFactory() {
        let data: Data? = nil
        
        do {
            let _ = try VersionFactory(data: data)
            XCTFail("Factory creation should not have succeeded.")
        }
        catch let e as VersionFactoryError {
            XCTAssertEqual(e, VersionFactoryError.noData)
        }
        catch {
            XCTFail("Wrong error")
        }
    }
    
    func testMalformedJSONGivenToFactory() {
        let dataFromAPI = try! Data(contentsOf: jsonDirectory.appendingPathComponent("malformed.json"))
        
        do {
            let _ = try VersionFactory(data: dataFromAPI)
            XCTFail("Factory creation should not have succeeded.")
        }
        catch let e as VersionFactoryError {
            XCTAssertEqual(e, VersionFactoryError.invalidJsonPayload)
        }
        catch {
            XCTFail("Wrong error.")
        }
    }
    
    func testValidJsonUnexectedFormat() {
        let dataFromAPI = try! Data(contentsOf: jsonDirectory.appendingPathComponent("valid_json_unexpected_format.json"))
        
        do {
            let _ = try VersionFactory(data: dataFromAPI)
            XCTFail("Factory creation should not have succeeded.")
        }
        catch let e as VersionFactoryError {
            XCTAssertEqual(e, VersionFactoryError.badPayloadFormat)
        }
        catch {
            XCTFail("Wrong error.")
        }
    }
    
    func testEmptyValidJsonFormat() {
        let dataFromAPI = try! Data(contentsOf: jsonDirectory.appendingPathComponent("empty_valid_format.json"))
        
        do {
            let factory = try VersionFactory(data: dataFromAPI)
            
            XCTAssertTrue(factory.minimumVersion == nil)
            XCTAssertTrue(factory.recommendedVersion == nil)
        }
        catch {
            XCTFail("Factory failed to create on valid empty json format.")
        }
    }
    
    
    //MARK: - Helper Methods
    func validFactoryFromAllFieldsJSON() -> VersionFactory {
        let dataFromAPI = try! Data(contentsOf: jsonDirectory.appendingPathComponent("all_fields.json"))
        
        return try! VersionFactory(data: dataFromAPI)
    }
    
    func validFactoryFromMinFieldsJSON() -> VersionFactory {
        let dataFromAPI = try! Data(contentsOf: jsonDirectory.appendingPathComponent("min_fields.json"))
        
        return try! VersionFactory(data: dataFromAPI)
    }
    
}

