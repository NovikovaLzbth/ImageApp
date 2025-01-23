//
//  ContentView.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI
import CoreData

final class ContentViewModel: ObservableObject {
    @Published var uiImage: UIImage?
    
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
                self.uiImage = uiImage
            }
        }
        task.resume()
    }
    
    func writeImage(uiImage: UIImage, persistenceController: PersistenceController) {
        guard let data = uiImage.pngData() else { return }
        let image = FoxImage(context: persistenceController.viewContext)
        
        image.data = data
        image.uuid = UUID()
        
        do {
            try persistenceController.viewContext.save()
            print("изображение сохранено")
        } catch {
            print("Ошибка сохранения в базу данных")
        }
    }
    
    func getImageFavourite(uiImage: UIImage, persistenceController: PersistenceController) -> [FoxImage]{
        let fetchRequest: NSFetchRequest<FoxImage> = FoxImage.fetchRequest()
        do{
            return try persistenceController.viewContext.fetch(fetchRequest)
        }catch{
            return[]
        }
    }
    
//
//    func deleteImage() {
//
//    }
}

struct ContentView: View {
    @State private var isShowFavouriteScreen: Bool = false
    
    @Environment(\.managedObjectContext) var persistenceController
    
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var favouriteView = FavouriteView()
    
    var body: some View {
        NavigationStack {
            //Изображение по URL
            VStack {
                if let image = viewModel.uiImage {
                    Image(uiImage: image)
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
                    
                    //кнопка для добавления в избранное
                    Button {
                        guard let uiImage = viewModel.uiImage else { return }
                        viewModel.writeImage(uiImage: uiImage, persistenceController: PersistenceController())
                    } label: {
                        Image("pngwing.png")
                    }
                    .padding(-230)
                    .scaleEffect(0.06)

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
                    favouriteView
                }
                    
            }
            
        }
        
    }
}

struct FavouriteView: View {
    var body: some View {
        VStack {
            List {
                VStack {
                   Text("fldsa'f")
                }
            }
        }
        .navigationTitle("Favourites")
    }
}

#Preview {
    ContentView()
}
