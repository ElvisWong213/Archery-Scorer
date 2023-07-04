//
//  SettingView.swift
//  Archery Scorer
//
//  Created by Elvis on 29/04/2023.
//

import SwiftUI

struct SettingView: View {
    let backgroundColor = Color("BackgroundColor")
    let backgroundColor2 = Color("BackgroundColor2")
    let buttonColor = Color("ButtonColor")
    let textColor = Color("TextColor")
    
    @State private var isPurchase = false
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var appState: BaseViewModel
    
    private let adCoordinator = AdCoordinator()

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Back") {
                        appState.baseView = .home
                    }
                    .foregroundColor(buttonColor)
                    .padding(.horizontal)
                    Spacer()
                }
                Text("Setting")
                    .font(.title).bold()
            }
            Form {
                Section(header: Text("Donate & Support❤️")) {
                    Button {
                        adCoordinator.loadAd()
                        adCoordinator.showAd()
                    } label: {
                        HStack {
                            Text("Watch AD")
                            Spacer()
                            Text("Free")
                        }
                    }
                    .foregroundColor(buttonColor)
                    ForEach(purchaseManager.products) { product in
                        Button {
                            Task {
                                do {
                                    if try await purchaseManager.purchase(product) != nil {
                                        isPurchase.toggle()
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(product.displayName)")
                                Spacer()
                                Text("\(product.displayPrice)")
                            }
                        }
                        .alert(isPresented: $isPurchase) {
                            Alert(title: Text("Thank for your support❤️"))
                        }
                    }
                    .foregroundColor(buttonColor)
                }
                Section(header: Text("About Me")) {
                    Link("Follow my Instagram", destination: URL(string: "https://instagram.com/elvis_coding")!)
                        .foregroundColor(buttonColor)
                    Link("Report bug / Feature request", destination: URL(string: "mailto:stevecode2021@gmail.com")!)
                        .foregroundColor(buttonColor)
                }
            }
            .task {
                Task {
                    do {
                        try await purchaseManager.loadProducts()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .foregroundColor(textColor)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(PurchaseManager())
            .environmentObject(BaseViewModel())
    }
}
