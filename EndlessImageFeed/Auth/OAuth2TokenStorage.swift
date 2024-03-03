//
//  OAuth2TokenStorage.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 04.03.2024.
//

import Foundation

class OAuth2TokenStorage {
    // Вычислимое свойство token
    var token: String {
        get {
            // Возвращаем сохраненное значение токена из хранилища, например, UserDefaults
            return UserDefaults.standard.string(forKey: "OAuth2Token") ?? ""
        }
        set {
            // При установке нового значения токена сохраняем его в хранилище, например, UserDefaults
            UserDefaults.standard.set(newValue, forKey: "OAuth2Token")
        }
    }
    static let shared = OAuth2TokenStorage()
    }

