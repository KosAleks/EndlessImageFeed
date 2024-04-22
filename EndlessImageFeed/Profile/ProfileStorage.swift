//
//  ProfileStorage.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 18.03.2024.
//

import Foundation

final class ProfileStorage {
    var userName: String {
        get {
            // Возвращаем сохраненное значение имени пользователя из UserDefaults
            return UserDefaults.standard.string(forKey: "userName") ?? "There is no name"
        }
        set {
            // При установке нового значения имени пользователя сохраняем его в UserDefaults
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
    }
    var firstName: String {
        get {
            return UserDefaults.standard.string(forKey: "firstName") ?? "There is no firstName"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstName")
        }
    }
    var lastName: String {
        get {
            return UserDefaults.standard.string(forKey: "lastName") ?? "There is no lastName"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastName")
        }
    }
    var bio: String {
        get {
            return UserDefaults.standard.string(forKey: "bio") ?? "There is no bio"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bio")
        }
    }
    var profileImage: String {
        get {
            return UserDefaults.standard.string(forKey: "profileImage") ?? "There is no profileImage"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "profileImage")
        }
    }
}
