//
//  AppVersion.swift
//  Chronicle
//
//  Created by Jon on 10/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Foundation


protocol Version {
    var version: String { get }
}

public struct SystemVersion: Version {
    public var version: String
}

public struct DetailedVersion: Version {
    
    public enum NotificationType: String {
        case always = "ALWAYS"
        case once = "ONCE"
    }
    
    public enum VersionType: String {
        case minimum
        case recommended
    }
    
    public let versionType: VersionType
    
    public let message: String
    
    public let storeUrl: URL
    
    public let notificationType: NotificationType
    
    public var version: String
}

//MARK: - Type comparision
func >(lhs: Version, rhs: Version) -> Bool {
    return lhs.version.compare(rhs.version, options: .numeric) == .orderedDescending
}

func <(lhs: Version, rhs: Version) -> Bool {
    return lhs.version.compare(rhs.version, options: .numeric) == .orderedAscending
}

func ==(lhs: Version, rhs: Version) -> Bool {
    return lhs.version == rhs.version
}


