//
//  CoinsView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct CoinsView: View {
    @State private var showActivityView = false
    @State private var showSettingsView = false
    @State private var showAddWalletView = false
    @State var loading = true
    @State var loadingError = false
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WalletAddress.name, ascending: true)],
        animation: .default)
    private var wallets: FetchedResults<WalletAddress>
    
    var body: some View {
        NavigationView {
            ZStack {
                if wallet.loadingTokens {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if wallets.count == 0 {
                    VStack {
                        Spacer()
                        Text("No wallets")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: appearance.getAppFont()))
                        Button(action: { showAddWalletView = true }, label: {
                            Text("Add wallet")
                                .font(.headline)
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .sheet(isPresented: $showAddWalletView) {
                            NavigationView { AddWalletView() }
                                .environmentObject(wallet)
                                .environmentObject(appearance)
                                .accentColor(appearance.getAppColor())
                        }
                        Spacer()
                    }
                } else if wallet.tokens.count == 0 && !wallet.loadingTokens {
                    VStack {
                        Spacer()
                        Text("No crypto")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: appearance.getAppFont()))
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(sortedTokens(), id: \.id) { token in
                            CryptoListItem()
                                .environmentObject(token)
                                .environmentObject(appearance)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        self.wallet.reload(reset: false, refresh: true)
                    }
                }
            }
            .navigationTitle(wallet.formatCurrency(value: wallet.value))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showActivityView.toggle() }, label: { Image(systemName: "clock").font(.headline) })
                    .sheet(isPresented: $showActivityView) {
                        ActivityView()
                            .environmentObject(wallet)
                            .environmentObject(appearance)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettingsView.toggle() }, label: { Image(systemName: "gear").font(.headline) })
                    .sheet(isPresented: $showSettingsView) {
                        SettingsView(showSettingsView: $showSettingsView)
                            .environmentObject(wallet)
                            .environmentObject(appearance)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
            }
        }
    }
    
    func sortedTokens() -> [Token] {
        return wallet.tokens.sorted(by: {
            $0.name.lowercased() < $1.name.lowercased()
        })
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView()
    }
}
