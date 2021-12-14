//
//  CryptoDetailView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct CryptoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var token: Token
    @EnvironmentObject var appearance: Appearance
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        List {
            Section(content: {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("\(wallet.formatCurrency(value: token.price?.value ?? 0))")
                            .font(.system(.largeTitle, design: appFont))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 4) {
                            Text(token.symbol.uppercased())
                                .font(.system(.body, design: appFont))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.vertical, 24)
            })
                .listRowBackground(
                    colorScheme == .light ?
                        Color(UIColor.secondarySystemBackground) :
                        Color(UIColor.systemBackground)
                )
            
            Section(content: {
                HStack {
                    Text("Today")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Label(token.percentChange(), systemImage: token.percentChange().contains("-") ? "arrow.down" : "arrow.up")
                        .font(.system(.headline, design: appFont))
                        .foregroundColor(token.percentChange().contains("-") ? .red : .green)
                }
            })
            
            Section(content: {
                HStack {
                    Text("Balance")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Text("\(token.tokenQuantity())")
                        .lineLimit(1)
                        .font(.system(.headline, design: appFont))
                }
                
                HStack {
                    Text("Value")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Text("\(wallet.formatCurrency(value: token.value()))")
                        .font(.system(.headline, design: appFont))
                }
            }, header: {
                Text("Wallet")
            })
            
            Section {
                Link(destination: URL(string: "https://etherscan.io/token/\(token.id)?a=\(wallet.currentWalletAddress)")!, label: {
                    Text("View on Etherscan")
                        .font(.system(.body, design: appFont))
                })
            }
            .foregroundColor(appearance.getAppColor())
        }
        .navigationTitle(token.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailView()
    }
}
