//
//  ContentView.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI

enum ImageLoaderError: Error {
  case incorrectImageData
}

final class ContentViewModel: ObservableObject {
    @Published var image: Image?
    
    init() {
        getImage()
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
                self.image = Image(uiImage: uiImage)
            }
        }
        task.resume()
    }

}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            
            ZStack{
                if let image = viewModel.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.pink, lineWidth: 4)
                        }
                }
                
                Button(action: {
                    viewModel.getImage()
                }, label: {
                    Text("Change image")
                        .font(.title)
                        .padding()
                        .background(Color.pink)
                        .foregroundStyle(.white)
                        .cornerRadius(40)
                        .padding()
                        .padding(-2)
                        .overlay {
                            RoundedRectangle(cornerRadius: 45)
                                .stroke(.pink, lineWidth: 5)
                        }
                })
                .frame(width: 250, height: 600, alignment: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}
