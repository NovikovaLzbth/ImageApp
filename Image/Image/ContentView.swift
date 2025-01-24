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
        
        DispatchQueue.main.async {
            do {
                try persistenceController.viewContext.save()
                print("изображение сохранено")
            } catch {
                print("Ошибка сохранения в базу данных")
            }
        }
    }
    
    func deleteAllImages(persistenceController: PersistenceController) {
        
//        do {
//            persistenceController.viewContext.delete(<#T##object: NSManagedObject##NSManagedObject#>, )
//        }
//            
//            DispatchQueue.main.async {
//                do {
//                    try persistenceController.viewContext.save()
//                    print("Все изображения удалены")
//                } catch {
//                    print("Ошибка при удалении изображений из базы данных")
//                }
//            }
    }
}

struct ContentView: View {
    @State private var isShowFavouriteScreen: Bool = false
    
    @Environment(\.managedObjectContext) var persistenceController
    
    @StateObject private var viewModel = ContentViewModel()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FoxImage.uuid, ascending: true)], animation: .default)
    private var images: FetchedResults<FoxImage>
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavourutesView(viewModel: viewModel)
                .tabItem {
                    Label("Selected", systemImage: "heart.fill")
                }
        }
    }
}
#Preview {
    ContentView()
}
        
struct HomeView: View {
    
    @State private var isShowFavouriteScreen: Bool = false
    
    @Environment(\.managedObjectContext) var persistenceController
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            //Заголовок Main screen
            ZStack {
                Text("Main screen")
                    .textScale(.default)
                    .font(.largeTitle)
                    .bold()
                    .position(x: 120, y: 50)
            }
            
            VStack {
                //Изображение по URL
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
                
                HStack {
                    //Кнопка смены изображения
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
                    
                    //Кнопка для добавления в избранное
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
            .position(x: 183, y: 10)
            .padding(.horizontal, 16)
        }
    }
}


struct FavourutesView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FoxImage.uuid, ascending: true)], animation: .default)
    private var images: FetchedResults<FoxImage>
    
    var body: some View {
            VStack {
//                Button {
////                    viewModel.deleteAllImages(persistenceController: PersistenceController())
//                } label: {
//                    Text("nn")
//                }

                List {
                    ForEach(images, id: \.id) { image in
                        if let data = image.data {
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
    }
}
