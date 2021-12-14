//
//  SettingsView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    @AppStorage("currentWalletAddress") private var currentWalletAddress: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appColor") private var appColor = AppColor.monochrome
    @AppStorage("appFont") private var appFont = AppFont.regular
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink {
                        WalletsView()
                            .environmentObject(wallet)
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        HStack {
                            Text("Wallets")
                                .font(.system(.body, design: appFont))
                            Spacer()
                            if currentWalletAddress != "" {
                                Text(wallet.formatAddress(address: currentWalletAddress))
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                })
                
                Section {
                    Picker(selection: $appColor, label: Text("Color").font(.system(.body, design: appFont))) {
                        ForEach(Array(AppColor.allCases), id: \.self) {
                            Text($0.rawValue.capitalized)
                                .font(.system(.body, design: appFont))
                        }
                    }
                    
                    Picker(selection: $appFont, label: Text("Font").font(.system(.body, design: appFont))) {
                        ForEach(Array(AppFont.allCases), id: \.self) {
                            Text($0.rawValue.capitalized)
                                .font(.system(.body, design: appFont))
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        Text("About")
                    } label: {
                        Text("About")
                            .font(.system(.body, design: appFont))
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "square.on.circle")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                        Spacer()
                    }
                    .padding(.vertical, 24)
                }
                .listRowBackground(
                    colorScheme == .light ?
                        Color(UIColor.secondarySystemBackground) :
                        Color(UIColor.systemBackground)
                )
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done", action: { self.showSettingsView = false })
                }
            }
        }
        .accentColor(appearance.getAppColor())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(true))
    }
}
