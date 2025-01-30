//
//  SpecificViewModel.swift
//  Image
//
//  Created by Elizaveta on 28.01.2025.
//

import SwiftUI
import CoreData

final class SpecificViewModel: ObservableObject {
    
    let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func addComment(text: String, objectID: NSManagedObjectID) {
        imageStorage.edit(objectID: objectID, comment: text)
    }
}

