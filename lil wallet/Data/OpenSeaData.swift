//
//  OpenSeaData.swift
//  lil wallet
//
//  Created by MacBook AIR on 20/07/2024.
//

import Foundation


class OpenSeaAsset: Codable, ObservableObject {
    var id: Int
    var image_url: String
    var name: String?
    var external_link: String?
    var traits: [OpenSeaAssetTrait]
    var description: String?
    var permalink: String

    func isSVG() -> Bool {
        return self.image_url.suffix(3) == "svg"
    }
}
