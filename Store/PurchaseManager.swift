//
//  PurchaseManager.swift
//  Archery Scorer
//
//  Created by Elvis on 29/04/2023.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

@MainActor
class PurchaseManager: ObservableObject {
    private let proudctIds = ["archery_marker_coffee","archery_marker_burger"]
    
    @Published private(set) var products: [Product] = []
    @Published private var productsLoaded = false
    
    func loadProducts() async throws {
        guard !self.productsLoaded else {return}
        
        self.products = try await Product.products(for: proudctIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await transaction.finish()
            return transaction
        case .userCancelled:
            return nil
        case .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
