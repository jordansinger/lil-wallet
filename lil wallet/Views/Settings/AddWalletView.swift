//
//  AddWalletView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct AddWalletView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    enum Field: Hashable {
        case name
        case address
    }
    @State var name = ""
    @State var address = ""
    @FocusState private var focusedField: Field?
    @AppStorage("currentWalletAddress") private var currentWalletAddress: String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WalletAddress.createdAt, ascending: true)],
        animation: .default)
    private var wallets: FetchedResults<WalletAddress>
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    @State var loading = false
    
    var body: some View {
        Form {
            Section(content: {
                TextField("Name", text: $name)
                    .focused($focusedField, equals: .name)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.next)
                
                TextField("Address", text: $address)
                    .focused($focusedField, equals: .address)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.done)
            }, footer: {
                Text("Ethereum address or ENS name")
            })
        }
        .font(.system(.body, design: appearance.getAppFont()))
        .toolbar(content: {
            ToolbarItem {
                Button(action: saveWallet, label: {
                    if self.loading {
                        ProgressView()
                    } else {
                        Text("Save")
                            .font(.headline)
                    }
                })
                .disabled(!isValid() || self.loading)
            }
        })
        .navigationTitle("Add Wallet")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: { autofocus() })
    }
    
    func autofocus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.focusedField = .name
        }
    }
    
    func isValid() -> Bool {
        return self.address != "" && (self.address.hasPrefix("0x") || self.address.hasSuffix(".eth"))
    }
    
    private func saveWallet() {
        if self.address.hasSuffix(".eth") {
            // address contains .eth, do reverse lookup
            reverseENSLookup(ensName: self.address)
        } else {
            addWallet(address: self.address)
        }
    }
    
    private func addWallet(address: String) {
        let newWallet = WalletAddress(context: viewContext)
        newWallet.createdAt = Date()
        newWallet.name = self.name == "" ? nil : self.name
        newWallet.address = address
        
        if wallets.count == 0 {
            // set to active wallet if it's the first one
            self.currentWalletAddress = address
            wallet.reload(reset: true, refresh: false)
        }

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func reverseENSLookup(ensName: String) {
        self.loading = true
        
        guard let url = URL(string: "https://0xmade-ens.vercel.app/api/ens/resolve?name=\(ensName)") else {
            print("Invalid URL")
            return
        }
                
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ReverseENSLookupResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.loading = false
                        addWallet(address: decodedResponse.address)
                    }
                }
            }

            // if we're still here it means there was a problem
            print("failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletView()
    }
}
