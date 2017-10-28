//
//  Chronicle.swift
//  Chronicle
//
//  Created by Jon on 10/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Foundation


/** Will obtain a version from a given URL JSON payload utilizing the Semantic Versioning 2.0 format. (http://semver.org/)
 */

public class Chronicle {
    
    enum Result {
        case success(VersionFactory)
        case failure(Error)
    }
    
    public typealias isMinimumVersionSatisfied = Bool
    
    /// (Required minimum version, isMinimumVersionSatisfied, Notification type)
    public typealias RequiredVersionBlock = (DetailedVersion, isMinimumVersionSatisfied, DetailedVersion.NotificationType) -> Void
    
    /// (Recommended version, isMinimumVersionSatisfied, Notification type)
    public typealias RecommendedVersionBlock = (DetailedVersion, isMinimumVersionSatisfied, DetailedVersion.NotificationType) -> Void
    
    public typealias ErrorBlock = (Error) -> Void
    
    
    public init() { }
    
    public func installedVersionNumber(bundle: Bundle) -> SystemVersion? {
        
        guard let currentVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return nil
        }
        guard let currentBuildNumberString = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil
        }
        
        return SystemVersion(version: currentVersionString + "." + currentBuildNumberString)
    }
    
    internal func loadConfiguration(from url: URL, completion: @escaping (Result) -> Void) {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            let result: Result
            if let error = error {
                result = Result.failure(error)
            } else {
                do {
                    let factory = try VersionFactory(data: data)
                    result = Result.success(factory)
                } catch let error {
                    result = Result.failure(error)
                }
            }
            
            completion(result)
        }
        dataTask.resume()
    }
    
    public func checkForUpdates(from url: URL,
                         appInfoBundle: Bundle = Bundle.main,
                         requiredVersion: @escaping RequiredVersionBlock,
                         recommendedVersion: @escaping RecommendedVersionBlock,
                         error: @escaping ErrorBlock) {
        
        guard let systemVersion = installedVersionNumber(bundle: appInfoBundle) else {
            return
        }
        
        loadConfiguration(from: url) { (result) in
            switch result {
            case .failure(let jsonGrabError):
                error(jsonGrabError)
                
            case .success(let factory):
                
                if let minimumVersion = factory.minimumVersion {
                    
                    let isMinimumVersionSatisfied = systemVersion > minimumVersion
                    
                    requiredVersion(minimumVersion,
                                    isMinimumVersionSatisfied,
                                    minimumVersion.notificationType)
                }
                if let suggestedVersion = factory.recommendedVersion {
                    let isMinimumVersionSatisfied = systemVersion > suggestedVersion
                    
                    recommendedVersion(suggestedVersion,
                                       isMinimumVersionSatisfied,
                                       suggestedVersion.notificationType)
                }
            }
        }
    }
    
}
