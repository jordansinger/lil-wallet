//
//  TransactionData.swift
//  lil wallet
//
//  Created by MacBook AIR on 20/07/2024.
//

import Foundation


class Transaction: ObservableObject {
    init(id: String, token: Token?, value: NSNumber?, price: NSNumber?, type: String, mined_at: Int, hash: String, status: String, block_number: Int, address_from: String?, address_to: String?, fee: Fee?) {
        self.id = id
        self.token = token
        self.value = value
        self.price = price
        self.type = type
        self.mined_at = mined_at
        self.hash = hash
        self.status = status
        self.block_number = block_number
        self.address_from = address_from
        self.address_to = address_to
        self.fee = fee
    }

    var id: String
    var token: Token?
    var value: NSNumber?
    var price: NSNumber?
    var type: String
    var mined_at: Int
    var hash: String
    var status: String
    var block_number: Int
    var address_from: String?
    var address_to: String?
    var fee: Fee?

    func transactionQuantity() -> Double {
        return Double(truncating: self.value ?? 0) / oneETHinWEI
    }

    func transactionValue() -> NSNumber {
        if self.price != nil && self.value != nil {
            return NSNumber(value: Double(truncating: self.price ?? 0) * self.transactionQuantity())
        } else {
            return 0
        }
    }

    func title() -> String {
        return "\(self.type.capitalized) \(self.token?.symbol.uppercased() ?? "")"
    }
}
