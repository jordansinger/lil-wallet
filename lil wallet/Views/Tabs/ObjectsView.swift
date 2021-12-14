//
//  ObjectsView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct ObjectsView: View {
    @State private var showActivityView = false
    @State private var showSettingsView = false
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
                if wallet.loadingObjects {
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
                        Button(action: { showSettingsView = true }, label: {
                            Text("Add wallet")
                                .font(.headline)
                        })
                        .buttonStyle(BorderedButtonStyle())
                        Spacer()
                    }
                } else if wallet.objects.count == 0 && !wallet.loadingObjects {
                    VStack {
                        Spacer()
                        Text("No objects")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: appearance.getAppFont()))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: 40)),
                            GridItem(.flexible(minimum: 40))
                        ]) {
                            ForEach(wallet.objects, id: \.token_id) { object in
                                ObjectGridItem()
                                    .environmentObject(object)
                            }
                        }
                        .padding()
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Objects")
            .navigationBarTitleDisplayMode(.inline)
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
}

struct ObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectsView()
    }
}
