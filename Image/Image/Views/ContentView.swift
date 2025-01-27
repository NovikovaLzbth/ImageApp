//
//  ContentView.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var imageStorage: ImageStorage
    
    var body: some View {
        TabView {
            HomeView(imageStorage: imageStorage)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavouritesView(imageStorage: imageStorage)
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}
#Preview {
    ContentView()
}
