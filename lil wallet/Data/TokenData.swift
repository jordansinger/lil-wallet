//
//  TokenData.swift
//  lil wallet
//
//  Created by MacBook AIR on 20/07/2024.
//

import Foundation

class Token: ObservableObject {
    init(id: String, name: String, symbol: String, quantity: String?, price: Price?, iconURL: String?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.quantity = quantity
        self.price = price
        self.iconURL = iconURL
    }

    var id: String
    var name: String
    var symbol: String
    var quantity: String?
    var price: Price?
    var iconURL: String?

    func value() -> NSNumber {
        if self.price != nil && self.quantity != nil {
            return NSNumber(value: Double(truncating: self.price?.value ?? 0) * self.tokenQuantity())
        } else {
            return 0
        }
    }

    func tokenQuantity() -> Double {
        return Double((self.quantity! as NSString).doubleValue) / oneETHinWEI
    }

    func percentChange() -> String {
        if self.price?.relative_change != nil {
            return String(format: "%.2f", Double(truncating: self.price?.relative_change ?? 0)) + "%"
        } else {
            return "0%"
        }
    }
}
