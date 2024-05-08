//
//  AppDelegate.swift
//  EndlessImageFeed
//
//  Created by Александра Коснырева on 17.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(          // 1 Создаём конфигурацию, используя доступный конструктор, и задаём ей имя "Main".
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self   // 2 ставляем delegateClass равным классу уже существующего делегата — SceneDelegate.
        return sceneConfiguration
    }
}

