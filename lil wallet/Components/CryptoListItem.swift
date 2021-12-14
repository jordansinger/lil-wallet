//
//  CryptoListItem.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct CryptoListItem: View {
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var token: Token
    @EnvironmentObject var appearance: Appearance
    
    var body: some View {
        let appFont = appearance.getAppFont()
        
        NavigationLink(destination: CryptoDetailView().environmentObject(token), label: {
            HStack(alignment: .center, spacing: 12) {
                AvatarView(text: token.name, iconURL: token.iconURL)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(token.name == "" ? "Untitled" : token.name)
                            .lineLimit(1)
                            .font(.system(.headline, design: appFont))
                        
                        Spacer()
                        
                        Text(token.percentChange())
                            .font(.system(.callout, design: appFont))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("\(wallet.formatCurrency(value: token.value()))")
                        .font(.system(.body, design: appFont))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 10)
        })
    }
}

struct CurrencyListItem_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListItem()
    }
}
