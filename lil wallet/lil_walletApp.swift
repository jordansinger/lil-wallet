//
//  lil_walletApp.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

@main
struct lil_walletApp: App {
    var appearance = Appearance()
    var wallet = Wallet()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wallet)
                .environmentObject(appearance)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
