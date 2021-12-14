//
//  ActivityDetailView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct ActivityDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var transaction: Transaction
    @EnvironmentObject var appearance: Appearance
    @EnvironmentObject var wallet: Wallet
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        List {
            Section(content: {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("\(wallet.formatCurrency(value: transaction.transactionValue()))")
                            .font(.system(.largeTitle, design: appFont))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(Date(timeIntervalSince1970: TimeInterval(transaction.mined_at)).formatted(date: .abbreviated, time: .shortened))
                            .font(.system(.body, design: appFont))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
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
                    Text("Type")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Text(transaction.type.capitalized)
                        .font(.system(.headline, design: appFont))
                }
                
                HStack {
                    Text("Status")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Text(transaction.status.capitalized)
                        .font(.system(.headline, design: appFont))
                }
                
                HStack {
                    Text("Amount")
                        .font(.system(.body, design: appFont))
                    Spacer()
                    Text("\(transaction.transactionQuantity())")
                        .font(.system(.headline, design: appFont))
                }
            })
            
            Section(content: {
                if let address_from = transaction.address_from {
                    Link(destination: URL(string: "https://etherscan.io/address/\(address_from)")!, label: {
                        HStack {
                            Text("From")
                                .font(.system(.body, design: appFont))
                            Spacer()
                            Text(wallet.formatAddress(address: address_from))
                                .font(.system(.headline, design: appFont))
                        }
                    })
                }
                
                if let address_to = transaction.address_to {
                    Link(destination: URL(string: "https://etherscan.io/address/\(address_to)")!, label: {
                        HStack {
                            Text("To")
                                .font(.system(.body, design: appFont))
                            Spacer()
                            Text(wallet.formatAddress(address: address_to))
                                .font(.system(.headline, design: appFont))
                        }
                    })
                }
            })
            .foregroundColor(.primary)
            
            if let token = transaction.token {
                Section(content: {
                    HStack {
                        Text(token.name)
                            .font(.system(.body, design: appFont))
                            .lineLimit(1)
                        Spacer()
                        Text(token.symbol.uppercased())
                            .font(.system(.headline, design: appFont))
                    }
                    
                    if let transactionPrice = transaction.price {
                        HStack {
                            Text("Price")
                                .font(.system(.body, design: appFont))
                            Spacer()
                            Text(wallet.formatCurrency(value: transactionPrice))
                                .font(.system(.headline, design: appFont))
                        }
                    }
                }, header: { Text("Token") })
            }
            
            if let fee = transaction.fee {
                Section(content: {
                    HStack {
                        Text("Value")
                            .font(.system(.body, design: appFont))
                            .lineLimit(1)
                        Spacer()
                        Text("\(fee.feeValue())")
                            .font(.system(.headline, design: appFont))
                    }
                    
                    HStack {
                        Text("Price")
                            .font(.system(.body, design: appFont))
                        Spacer()
                        Text(wallet.formatCurrency(value: fee.feePrice()))
                            .font(.system(.headline, design: appFont))
                    }
                }, header: { Text("Fee") })
            }

            Section {
                Link(destination: URL(string: "https://etherscan.io/tx/\(transaction.hash)")!, label: {
                    Text("View on Etherscan")
                        .font(.system(.body, design: appFont))
                })
            }
            .foregroundColor(appearance.getAppColor())
        }
        .navigationBarTitle(transaction.title())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView()
    }
}
