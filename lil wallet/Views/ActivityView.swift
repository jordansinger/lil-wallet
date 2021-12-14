//
//  ActivityView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    @State var loading = true
    @State var loadingError = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if wallet.loadingTransactions {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if wallet.transactions.count == 0 {
                    VStack {
                        Spacer()
                        Text("No activity")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: appearance.getAppFont()))
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(wallet.transactions, id: \.id) { transaction in
                            ActivityListItem()
                                .environmentObject(appearance)
                                .environmentObject(transaction)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .accentColor(appearance.getAppColor())
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
