//
//  HomeViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var uiImage: UIImage?
    @Published var isShowProgressView = false
    
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
        self.getImage()
    }
    
    func getImage() {
        guard let url = URL(string: "https://randomfox.ca/images/\(Int.random(in: 1...121)).jpg") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error)")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            guard let uiImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.uiImage = uiImage
            }
        }
        task.resume()
    }
    
    func saveImage() {
        guard let uiImage = uiImage else { return }
        
        imageStorage.writeImage(uiImage: uiImage)
    }
}
