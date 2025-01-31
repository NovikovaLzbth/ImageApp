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
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(images, id: \.self) { image in
                        if let data = image.data {
                            if let uiImage = UIImage(data: data) {
                                NavigationLink {
                                    SpecificView(imageStorage: viewModel.imageStorage, fieldValueName: "", image: image, fieldValueDescription: "", fieldValueAge: "")
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 3)
                                        }
                                    
                                }
                            }
                        }
                    }
                    .onDelete { index in
                        viewModel.delete(at: index)
                    }
                }
            }
            .navigationBarTitle(Text("Favourites"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.deleteAll()
                    } label: {
                        Text("Delete all")
                    }
                }
            }
        }
    }
}
