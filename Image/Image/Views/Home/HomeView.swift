//
//  HomeView.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var isShowProgressView = false
    
    init(imageStorage: ImageStorage) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(imageStorage: imageStorage))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    VStack {
                        //Изображение по URL
                        if let image = viewModel.uiImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
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
                                viewModel.saveImage()
                            } label: {
                                Image("pngwing.png")
                            }
                            .padding(-230)
                            .scaleEffect(0.06)
                            
                        }
                    }
                    .navigationBarTitle(Text("Main screen"))
                }
            }
            
        }
        .padding(.horizontal, 16)
        
    }
    
}
