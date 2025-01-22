//
//  ContentView.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI
import CoreData

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
    
    func writeImage() {
        
    }
    
    func deleteImage() {
        
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var isShowFavouriteScreen: Bool = false
    
    var body: some View {
        NavigationStack {
            //Изображение по URL
            VStack {
                if let image = viewModel.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.pink, lineWidth: 4)
                        }
                }
                
                //Кнопка смены изображения
                HStack {
                    Button(action: {
                        viewModel.getImage()
                    }, label: {
                        Text("Change image")
                            .font(.system(size: 20))
                            .padding()
                            .background(Color.pink)
                            .foregroundStyle(.white)
                            .cornerRadius(13)
                            .padding()
                            .padding(-8)
                        
                    })
                    .frame(height: 120)
                    
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("Main screen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowFavouriteScreen = true
                    } label: {
                        Text("Избранное")
                    }
                }
            }
            //Переход на экран Избранное
            .navigationDestination(isPresented: $isShowFavouriteScreen) {
                VStack {
                    Text("Favourite")
                }
                .navigationTitle("Favourites")
            }
            
        }
        
    }
}


#Preview {
    ContentView()
}
