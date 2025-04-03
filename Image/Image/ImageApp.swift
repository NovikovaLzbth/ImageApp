//
//  ImageApp.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI

private let persistenceController = PersistenceController()
private let imageStorage = ImageStorage(persistenceController: persistenceController)

@main
struct ImageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .environmentObject(imageStorage)
        }
    }
}
