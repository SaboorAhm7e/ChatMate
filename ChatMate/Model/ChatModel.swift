//
//  ChatModel.swift
//  ChatMate
//
//  Created by saboor on 19/01/2026.
//

import Foundation
import FirebaseFirestore

struct ChatModel {
    let chatId: String
    let members: [String]
    let lastMessage: String?
    let lastMessageSender: String?
    let lastMessageTime: Timestamp?
    
    init?(document: DocumentSnapshot) {
        let data = document.data()
        self.chatId = document.documentID
        self.members = data?["members"] as? [String] ?? []
        self.lastMessage = data?["lastMessage"] as? String
        self.lastMessageSender = data?["lastMessageSender"] as? String
        self.lastMessageTime = data?["lastMessageTime"] as? Timestamp
    }
}
