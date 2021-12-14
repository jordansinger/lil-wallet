//
//  EditWalletsView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct WalletsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WalletAddress.name, ascending: true)],
        animation: .default)
    private var wallets: FetchedResults<WalletAddress>
    @AppStorage("currentWalletAddress") private var currentWalletAddress: String = ""
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        ZStack {
            if wallets.count == 0 {
                VStack {
                    Spacer()
                    Text("No wallets")
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: appearance.getAppFont()))
                    Spacer()
                }
            } else {
                List {
                    Section {
                        ForEach(wallets, id: \.createdAt) { savedWallet in
                            Button(action: { setCurrentWalletAddress(address: savedWallet.address ?? "") }, label: {
                                Label {
                                    HStack {
                                        Text(savedWallet.name ?? "Wallet")
                                            .foregroundColor(.primary)
                                            .font(.system(.body, design: appFont))
                                            .lineLimit(1)
                                        Spacer()
                                        Text(wallet.formatAddress(address: savedWallet.address ?? ""))
                                            .font(.system(.body, design: .monospaced))
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                } icon: {
                                    Image(systemName: currentWalletAddress == savedWallet.address ? "checkmark" : "")
                                        .font(.headline)
                                }
                            })
                        }
                        .onDelete(perform: deleteWallets)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddWalletView()
                        .environmentObject(wallet)
                        .environment(\.managedObjectContext, viewContext)
                } label: {
                    Text("Add")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Wallets")
    }
    
    func setCurrentWalletAddress(address: String) {
        let existingCurrentWalletAddress = self.currentWalletAddress
        if existingCurrentWalletAddress != address {
            self.currentWalletAddress = address
            self.wallet.reload(reset: true, refresh: false)
        }
    }

    private func deleteWallets(offsets: IndexSet) {
        withAnimation {
            offsets.map { wallets[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct EditWalletsView_Previews: PreviewProvider {
    static var previews: some View {
        WalletsView()
    }
}
