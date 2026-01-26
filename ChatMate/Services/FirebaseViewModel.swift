//
//  FireStoreManager.swift
//  ChatMate
//
//  Created by saboor on 19/01/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine


class FirebaseViewModel {
    
    // MARK: - Fetch user
    func fetchUser(id:String) -> Future<UserModel,Error> {
        return Future { promise in
            Firestore.firestore()
                .collection("users")
                .document(id)
                .getDocument { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    guard let snapshot = snapshot,
                          let user = UserModel(document: snapshot)
                    else {
                        promise(.failure(
                            NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey:"User parsing failed"])
                        ))
                        return
                    }
                    promise(.success(user))
                }
        }
    }
    // MARK: - fetch people
    func fetchPeople() -> Future<[UserModel],Error> {
        let userid = Auth.auth().currentUser?.uid ?? "0"
        return Future { promise in
            Firestore.firestore()
                .collection("users")
                .whereField("uid", isNotEqualTo: userid)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    guard let snapshot = snapshot
                    else {
                        promise(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey:"users parsing failed"])))
                        return
                    }
                    let users = snapshot.documents.compactMap { document in
                        UserModel(document: document)
                    }
                    promise(.success(users))
                }
        }
    }
    // MARK: - fetch chats
    func fetchChats() -> Future<[ChatModel],Error> {
        
        return Future { promise in
            guard let userid = Auth.auth().currentUser?.uid else {
                promise(.failure(URLError(.userAuthenticationRequired)))
                return
            }
            Firestore.firestore()
                .collection("chats")
                .whereField("members", arrayContains: userid)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    guard let snapshot = snapshot else {
                        promise(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey:"chats parsing failed."])))
                        return
                    }
                    let chats = snapshot.documents.compactMap { documnet in
                        ChatModel(document: documnet)
                    }
                    promise(.success(chats))
                }
        }
        
        
    }
}
