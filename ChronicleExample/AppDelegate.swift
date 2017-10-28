//
//  AppDelegate.swift
//  ChronicleExample
//
//  Created by Jon Cardasis on 10/28/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import UIKit
import Chronicle

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let currentAppVersion = Chronicle().installedVersionNumber(bundle: Bundle.main)
        print("Current App Version: \(String(describing: currentAppVersion))")
        
        // Chronicle version checking
        let localOrRemoteURL: URL = Bundle.main.bundleURL.appendingPathComponent("JSON/all_fields.json")
        handleNewVersionsFound(for: localOrRemoteURL)
        

        return true
    }
    
    
    private func handleNewVersionsFound(for url: URL) {
        
        Chronicle().checkForUpdates(from: url,
                                    requiredVersion: { (version, isMinimumVersionSatisfied, notificationType) in
                                        if notificationType == .once {
                                            if UserDefaults.standard.bool(forKey: "\(version.version)OnceTrigger") {
                                                return // Break out
                                            }
                                            UserDefaults.standard.set(true, forKey: "\(version.version)OnceTrigger")
                                        }
                                        else if (!isMinimumVersionSatisfied) { //notificationType garunteed to be `.always`
                                            print("""
                                                Version \(version.version) is available.
                                                You are required to download this version to continue using this application.
                                                Visit \(version.storeUrl) to upgrade.
                                                """)
                                        }
        },
                                    recommendedVersion: { (version, isMinimumVersionSatisfied, notificationType) in
                                        print("""
                                            Version \(version.version) is available!
                                            You should go and download it!
                                            """)
                                        
        }) { (error) in
            print("Woah there! Appears to be an error retrieving version data.")
            // Usually don't want to display anything to user at this point
        }
    }

}

