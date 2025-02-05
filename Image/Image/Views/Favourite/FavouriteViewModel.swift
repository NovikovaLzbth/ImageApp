//
//  FavouriteViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI

final class FavouritesViewModel: ObservableObject {
    let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func deleteAll() {
        imageStorage.deleteAll()
    }
    
}

