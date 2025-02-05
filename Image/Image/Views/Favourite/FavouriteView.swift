//
//  FavouriteView.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

struct FavouritesView: View {
    @StateObject private var viewModel: FavouritesViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FoxImage.uuid, ascending: true)], animation: .default)
    private var images: FetchedResults<FoxImage>
    
    init(imageStorage: ImageStorage) {
        _viewModel = StateObject(wrappedValue: FavouritesViewModel(imageStorage: imageStorage))
    }
    
    let colomn = [
        GridItem(.fixed(160)),
        GridItem(.fixed(160))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: colomn, alignment: .center) {
                        ForEach(images, id: \.self) { image in
                            if let data = image.data {
                                if let uiImage = UIImage(data: data) {
                                    NavigationLink {
                                        SpecificView(imageStorage: viewModel.imageStorage, fieldValueName: "", image: image, fieldValueDescription: "", fieldValueAge: "")
                                    } label: {
                                        VStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 160, height: 160)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(.black, lineWidth: 2)
                                                }
                                            
                                            Text("\(image.name ?? " ")")
                                                .foregroundStyle(.black)
                                            
                                            if let date = image.date {
                                                Text("\(dateAndTime(date))")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Favourites"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Menu("Sorting") {
                            Button("Default", action: viewModel.deleteAll)
                            Button("By name", action: viewModel.deleteAll)
                            Button("By date", action: viewModel.deleteAll)
                        }
                        Button("Delete all", action: viewModel.deleteAll)
                    } label: {
                        Label("", systemImage: "line.3.horizontal")
                    }
                }
            }
        }
        
    }
    
    private func dateAndTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}

