//
//  Imyarek_SwiftUIApp.swift
//  Imyarek_SwiftUI
//
//  Created by Авазбек on 20.11.2024.
//

import SwiftUI

@main
struct Imyarek_SwiftUIApp: App {
    init() {
        _ = DatabaseService.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
