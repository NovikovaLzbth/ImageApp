//
//  FavouriteViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

final class FavouritesViewModel: ObservableObject {
    @Published var sortType: SortType = .defaultOrder
    
    enum SortType {
        case defaultOrder
        case byName
        case byDate
    }
    
    let imageStorage: ImageStorage
    
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func deleteAll() {
        imageStorage.deleteAll()
    }
    
}


