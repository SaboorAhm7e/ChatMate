//
//  DataManager.swift
//  ChatMate
//
//  Created by saboor on 07/01/2026.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    private let key = "isAuntheticate"
    
    var isAuthenticate : Bool {
        get { UserDefaults.standard.bool(forKey: "isAuntheticate") }
        set { UserDefaults.standard.set(newValue, forKey: "isAuntheticate") }
    }
}
