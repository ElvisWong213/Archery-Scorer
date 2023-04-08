//
//  ReviewHandler.swift
//  Archery Scorer
//
//  Created by Elvis on 11/9/2022.
//

import Foundation
import StoreKit

class ReviewHandler {
    static func requestReview() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
        
    }
}
