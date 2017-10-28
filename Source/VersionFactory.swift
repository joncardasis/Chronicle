//
//  VersionFactory.swift
//  Chronicle
//
//  Created by Jon on 10/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Foundation

internal enum VersionFactoryError: Error {
    case noData
    case invalidJsonPayload
    case badPayloadFormat
}

internal struct VersionFactory {
    
    private(set) var recommendedVersion: DetailedVersion?
    private(set) var minimumVersion: DetailedVersion?
    
    
    init(data: Data?) throws {
        guard let data = data else {
            throw VersionFactoryError.noData
        }
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: AnyObject]  else {
            throw VersionFactoryError.invalidJsonPayload
        }
        guard let payload = json["ios"] else {
            throw VersionFactoryError.badPayloadFormat
        }
        
        // Parse payload into Version objects
        if let version = payload["minimum_version"] as? [String: String] {
            if let message = version["display_msg"],
                let storeUrl = version["store_link"].flatMap({ URL(string: $0) }),
                let versionString = version["version"] {
            
                let notification = version["notification_type"].flatMap({ DetailedVersion.NotificationType(rawValue: $0) }) ?? .once
                
                let minVersion = DetailedVersion(versionType: .minimum,
                                            message: message,
                                            storeUrl: storeUrl,
                                            notificationType: notification,
                                            version: versionString)
                minimumVersion = minVersion
            } else {
                throw VersionFactoryError.badPayloadFormat
            }
        }
        if let version = payload["recommended_version"] as? [String: String] {
            if let message = version["display_msg"],
                let storeUrl = version["store_link"].flatMap({ URL(string: $0) }),
                let versionString = version["version"] {
                
                let notification = version["notification_type"].flatMap({ DetailedVersion.NotificationType(rawValue: $0) }) ?? .once
                
                let recVersion = DetailedVersion(versionType: .recommended,
                                                 message: message,
                                                 storeUrl: storeUrl,
                                                 notificationType: notification,
                                                 version: versionString)
                recommendedVersion = recVersion
            } else {
                throw VersionFactoryError.badPayloadFormat
            }
        }
    }
    
}
