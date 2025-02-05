//
//  HomeView.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

//Смена кнопки добавления в избранное по нажатию
struct PressedButtonStyle: ButtonStyle {
    let title: String
    let systemImage: String
    let pressedImage: String
    
    func makeBody(configuration: Configuration) -> some View {
        let imageName = configuration.isPressed ? pressedImage : systemImage
        return Label(title, systemImage: imageName)
            .symbolEffect(.scale.up, isActive: configuration.isPressed)
    }
}

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var isShowProgressView = false
    @State private var showAlert = false
    
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
                                .cornerRadius(10)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 3)
                                }
                                .padding(16)
                        } else {
                            if viewModel.url != nil {
                                Image("pngwing.png")
                                    .resizable()
                                    .scaledToFit ()
                                    .frame(width: 160)
                                    .cornerRadius(10)
                            }
                        }
                        
                        HStack {
                            //Кнопка смены изображения
                            Button(action: {
                                if viewModel.isConnected {
                                    viewModel.getImage()
                                } else {
                                    showAlert = true
                                }
                            }, label: {
                                Text("Change image")
                                    .font(.system(size: 20))
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundStyle(.white)
                                    .cornerRadius(13)
                                    .padding()
                                    .padding(-8)
                                
                            })
                            .frame(height: 120)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("No Internet сonnection"),
                                      message: Text("Please check your internet connection and try again"),
                                      dismissButton: .default(Text("OK")))
                            }
                            
                            Button {
                                if viewModel.isConnected {
                                    viewModel.saveImage()
                                } else {
                                    showAlert = true
                                }
                            } label: {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color.red)
                                    .scaleEffect(1.5)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                    }
                    .navigationBarTitle(Text("Main screen"))
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Internet сonnection"),
                              message: Text("Please check your internet connection and try again"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}

// TODO: - Remove

struct Neumorphic: ViewModifier {
    var bgColor: Color
    @Binding var isPressed: Bool

    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: self.isPressed ? 7: 10, x: self.isPressed ? -5: -15, y: self.isPressed ? -5: -15)
                        .shadow(color: .black, radius: self.isPressed ? 7: 10, x: self.isPressed ? 5: 15, y: self.isPressed ? 5: 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
            )
            .scaleEffect(self.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}

extension View {
    func neumorphic(isPressed: Binding<Bool>, bgColor: Color) -> some View {
        self.modifier(Neumorphic(bgColor: bgColor, isPressed: isPressed))
    }
}
