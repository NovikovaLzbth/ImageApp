//
//  SpecificViewModel.swift
//  Image
//
//  Created by Elizaveta on 28.01.2025.
//

import SwiftUI
import CoreData

struct Fox {
    var name: String?
    var discription: String?
    var age: Int16?
}

final class SpecificViewModel: ObservableObject {
    
    let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func delete(image: FoxImage) {
        imageStorage.delete(image: image)
    }
    
    func addComment(objectID: NSManagedObjectID, fox: Fox) {
        imageStorage.edit(objectID: objectID, fox: fox)
    }
}

