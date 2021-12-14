//
//  ContentView.swift
//  lil wallet
//
//  Created by Jordan Singer on 11/28/21.
//

import SwiftUI

struct ContentView: View {
    @State var activeTab = 0
    @EnvironmentObject var wallet: Wallet
    @EnvironmentObject var appearance: Appearance
    @Environment(\.managedObjectContext) private var viewContext
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if showLaunchScreen() {
                // loading view
                VStack {
                    Spacer()
                    Text(Image(systemName: "square.on.circle"))
                        .font(.system(size: 56, weight: .medium))
                        .foregroundColor(appearance.getAppColor())
                    Spacer()
                }
            } else {
                TabView(selection: $activeTab) {
                    CoinsView()
                        .environmentObject(wallet)
                        .environment(\.managedObjectContext, viewContext)
                        .tabItem {
                            Image(systemName: "circle")
                                .environment(\.symbolVariants, activeTab == 0 ? .fill : .none)
                            Text("Coins")
                        }
                        .tag(0)
                    
                    ObjectsView()
                        .environment(\.managedObjectContext, viewContext)
                        .tabItem {
                            Image(systemName: "app")
                                .environment(\.symbolVariants, activeTab == 1 ? .fill : .none)
                            Text("Objects")
                        }
                        .tag(1)
                }
                .accentColor(appearance.getAppColor())
            }
        }
        .animation(.easeInOut(duration: 0.16), value: showLaunchScreen())
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
    
    func showLaunchScreen() -> Bool {
        // show launch screen if we're waiting for portfolio/tokens, OR if timer is at 0
        return (wallet.loadingPortfolio || wallet.loadingTokens) && self.timeRemaining > 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
