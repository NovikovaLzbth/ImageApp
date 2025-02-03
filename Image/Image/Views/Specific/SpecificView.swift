//
//  SpecificView.swift
//  Image
//
//  Created by Elizaveta on 28.01.2025.
//

import SwiftUI
import CoreData

struct SpecificView: View {
    
    @StateObject private var viewModel: SpecificViewModel
    
    @State var fieldValueName: String
    @State var fieldValueDescription: String
    @State var fieldValueAge: String
    
    var image: FoxImage = FoxImage()
    
    init(imageStorage: ImageStorage, fieldValueName: String, image: FoxImage, fieldValueDescription: String, fieldValueAge: String) {
        _viewModel = StateObject(wrappedValue: SpecificViewModel(imageStorage: imageStorage))
        self.image = image
        self.fieldValueName = fieldValueName
        self.fieldValueDescription = fieldValueDescription
        self.fieldValueAge = fieldValueAge
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    VStack {
                        //Передача изображения
                        if let imageData = image.data, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 3)
                                }
                        }
                        
                        //Ввод комментария
                        HStack {
                            TextField("Name", text: $fieldValueName)
                            TextField("Description", text: $fieldValueDescription)
                            TextField("Age", text: $fieldValueAge)
                            
                            Button {
                                let fox = Fox(
                                    name: fieldValueName,
                                    discription: fieldValueDescription,
                                    age: Int16(fieldValueAge)
                                )
                                
                                viewModel.addComment(objectID: image.objectID, fox: fox)
                            } label: {
                                Label("Send", systemImage: "arrowshape.turn.up.right.fill")
                                    .colorMultiply(.black)
                            }
                        }
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(16)
                    
                    Text("Your comments:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(16)
                    
                    //Сохранение комментарияв списке
                    if let name = image.name,
                       let discription = image.discription {
                        
                        Text("Name: \(name) \nDescription: \(discription)\nAge: \(image.age)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
