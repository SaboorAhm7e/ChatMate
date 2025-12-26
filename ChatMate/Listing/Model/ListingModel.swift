//
//  ListingModel.swift
//  ChatMate
//
//  Created by saboor on 26/12/2025.
//

import Foundation

nonisolated
struct ListingModel: Hashable, Sendable {
    let name : String
    let message : String
    let image : String
}
extension ListingModel {
    static let dummyData : [ListingModel] = [
        .init(name: "Elon Musk", message: "i just launch new space ship to mars", image: "em"),
        .init(name: "Sundar Pichai", message: "goolge sheet is now free,be first to grab it this year", image: "sp"),
        .init(name: "Tim Cook", message: "new iPhone model is cheapest in history", image: "tk"),
    ]
}
