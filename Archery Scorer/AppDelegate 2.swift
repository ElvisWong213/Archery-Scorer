//
//  AppDelegate.swift
//  Archery Scorer
//
//  Created by Elvis on 6/7/2022.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private let actionService = ActionService.shared

    // 3
    func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
    // 4
        if let shortcutItem = options.shortcutItem {
          actionService.action = Action(shortcutItem: shortcutItem)
        }

        // 5
        let configuration = UISceneConfiguration(
          name: connectingSceneSession.configuration.name,
          sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
