//
//  MessageModel.swift
//  ChatMate
//
//  Created by saboor on 19/01/2026.
//

import Foundation
import FirebaseFirestore

nonisolated
struct MessageModel: Hashable {
    let id: String
    let senderId: String
    let text: String
    let time: Timestamp
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        self.id = document.documentID
        self.senderId = data["senderId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.time = data["time"] as? Timestamp ?? Timestamp()
    }
}
