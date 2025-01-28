//
//  SpecificViewModel.swift
//  Image
//
//  Created by Elizaveta on 28.01.2025.
//

import SwiftUI

final class SpecificViewModel: ObservableObject {
    let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func addComment() {
        
        imageStorage.edit()
    }
}
