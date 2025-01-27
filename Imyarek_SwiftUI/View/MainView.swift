//
//  MainView.swift
//  Imyarek_SwiftUI
//
//  Created by Авазбек on 09.12.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ChatView()
            }
            .tabItem {
                Label("Поиск", systemImage: "magnifyingglass")
            }

            NavigationStack {
                ContentView()
            }
            .tabItem {
                Label("Настройки", systemImage: "gear")
            }
        }
    }
}

#Preview {
    MainView()
}
