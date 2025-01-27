//
//  FavouriteViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI

final class FavouritesViewModel: ObservableObject {
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func delete(at offsets: IndexSet) {
        imageStorage.delete(at: offsets, images: imageStorage.fetchImages())
    }
    
    func deleteAll() {
        imageStorage.deleteAll()
    }
    
}

