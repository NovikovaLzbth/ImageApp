//
//  HomeViewModel.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import Network

final class HomeViewModel: ObservableObject {
    
    @Published var uiImage: UIImage?
    @Published var image: UIImage?
    @Published var isShowProgressView = false
    @Published var url: URL?
    @Published var isConnected: Bool = true
    
    private var monitor: NWPathMonitor
    
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        self.getImage()
        
    }
    
    func getImage() {
        guard isConnected else {
            print("нет интернета")
            return
        }
        
        guard let url = URL(string: "https://randomfox.ca/images/\(Int.random(in: 1...121)).jpg") else { return }
        self.url = url
        
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
