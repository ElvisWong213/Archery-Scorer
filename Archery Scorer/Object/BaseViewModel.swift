//
//  BaseViewModel.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var baseView: UserFlow = .home
    
    func checkDeepLink(url: URL) -> Bool {
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else {
            return false
        }
        
        switch host {
        case UserFlow.home.rawValue:
            baseView = .home
            break
        case UserFlow.add.rawValue:
            baseView = .add
            break
        case UserFlow.statistic.rawValue:
            baseView = .statistic
            break
        case UserFlow.setting.rawValue:
            baseView = .setting
            break
        default:
            return false
        }
        return true
    }

    enum UserFlow: String {
        case home = "home"
        case add = "add"
        case record = "record"
        case review = "review"
        case statistic = "statistic"
        case setting = "setting"
    }
}
