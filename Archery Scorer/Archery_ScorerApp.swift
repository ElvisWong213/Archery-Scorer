//
//  Archery_ScorerApp.swift
//  Archery Scorer
//
//  Created by Steve on 16/3/2022.
//

import SwiftUI

var shortcutItemToHandle: UIApplicationShortcutItem?

@main
struct Archery_ScorerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var lifeCycle
//    let persistenceController = PersistenceController.shared
    @State private var dataController = DataController()
    @StateObject var appState = BaseViewModel()
    @StateObject var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
//            RecordView(bowData: .constant([58, 150 ,10]), time: .constant(Date.now))
            ContentView()
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(appState)
                .environmentObject(purchaseManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onOpenURL { url in
                    if appState.checkDeepLink(url: url) {
                        print("from deep link")
                    } else {
                        print("fall back deep link")
                    }
                }
        }
        .onChange(of: lifeCycle) { newLifeCyclePhase in
            if newLifeCyclePhase == .active {
                guard let name = shortcutItemToHandle?.type else { return }
                switch name {
                    case "CreateAction":
                        appState.baseView = .add
                    case "StatisticsAction":
                        appState.baseView = .statistic
                    default:
                        appState.baseView = .home
                }
                shortcutItemToHandle = nil
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            shortcutItemToHandle = shortcutItem
        }
    }
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToHandle = shortcutItem
    }
}
