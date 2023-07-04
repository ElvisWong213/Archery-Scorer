//
//  AdCoordinator.swift
//  Archery Scorer
//
//  Created by Elvis on 29/04/2023.
//

import GoogleMobileAds
import SwiftUI

class AdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    private var keys: NSDictionary?
    
    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        if let path = Bundle.main.path(forResource: "Key", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        guard let key = keys?["ADKey"] as? String else {
            return
        }
        GADInterstitialAd.load(
            withAdUnitID: key, request: GADRequest()
        ) { ad, error in
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
    }

    func showAd() {
        guard let interstitial = interstitial else {
            return print("Ad wasn't ready")
        }
        let root = UIApplication.shared.windows.first?.rootViewController
        
        interstitial.present(fromRootViewController: root!)
    }
}
