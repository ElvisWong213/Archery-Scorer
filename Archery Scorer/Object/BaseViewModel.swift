//
//  BaseViewModel.swift
//  Archery Scorer
//
//  Created by Elvis on 31/03/2023.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var baseView: UserFlow = .home

    enum UserFlow {
        case home, add, record, review, statistic
    }
}
