//
//  FavouriteViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

final class FavouritesViewModel: ObservableObject {
//    @Published var images: [FoxImage]?
    @Published var sortType: SortType = .defaultOrder
    
    enum SortType {
        case defaultOrder
        case byName
        case byDate
    }
    
    let imageStorage: ImageStorage
    
    
    init(imageStorage: ImageStorage /*, images: [FoxImage]*/) {
        self.imageStorage = imageStorage
//        self.images = images
    }
    
    func deleteAll() {
        imageStorage.deleteAll()
    }
    
    func sort(images: [FoxImage]) -> [FoxImage] {
        
        let sortedImages = images.sorted {
            
            if
                let name1 = $0.name,
                let name2 = $1.name
            {
                return name1 < name2
            } else {
                return false
            }
        }
        
        return sortedImages
        /*
        switch sortType {
        case .byName:
            let sortedImages = images.sort {
                guard
                    let name1 = $0.name,
                    let name2 = $1.name
                else {
                    return images
                }
            }
            
//            return images.sort {
//                guard let name1 = $0.name, let name2 = $1.name else { return false }
//                return name1 < name2
//            }
            print(images)
            
        case .byDate:
            images.sort {
                guard let date1 = $0.date, let date2 = $1.date else { return false }
                return date1 < date2
            }
            
        case .defaultOrder:
            break
        }
         */
    }
}

