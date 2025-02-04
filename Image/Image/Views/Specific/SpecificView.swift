//
//  SpecificView.swift
//  Image
//
//  Created by Elizaveta on 28.01.2025.
//

import SwiftUI
import CoreData

struct ButtonPressed: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View { configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}


struct SpecificView: View {
    
    @StateObject private var viewModel: SpecificViewModel
    
    @State var fieldValueName: String
    @State var fieldValueDescription: String
    @State var fieldValueAge: String
    @State private var isEdit = false
    
    @FocusState private var nameIsFocused: Bool
    
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
                        
                        Text("Your comment:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 36)
                        
                        //Комментарий
                        HStack {
                            if let name = image.name,
                               let discription = image.discription {
                                
                                HStack {
                                    if isEdit {
                                        
                                        VStack {
                                            TextField("Name...", text: $fieldValueName)
                                            TextField("Description...", text: $fieldValueDescription)
                                            TextField("Age...", text: $fieldValueAge)
                                                
                                        }
                                        
                                        Button("Save") {
                                            let fox = Fox(
                                                name: fieldValueName,
                                                discription: fieldValueDescription,
                                                age: Int16(fieldValueAge)
                                            )
                                            
                                            viewModel.addComment(objectID: image.objectID, fox: fox)
                                            
                                            isEdit = false
                                        }
                                    } else {
                                        
                                        Text("Name: \(name) \nDescription: \(discription)\nAge: \(image.age)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Button (action: {
                                            fieldValueName = name
                                            fieldValueDescription = discription
                                            fieldValueAge = "\(image.age)"
                                            isEdit = true
                                        }, label: {
                                            Label("", systemImage: "pencil")
                                                .colorMultiply(.black)
                                        })
                                        .scaleEffect(1.8)
                                    }
                                }
                            } else {
                                VStack {
                                    TextField("Name...", text: $fieldValueName, onCommit: {
                                        let fox = Fox(
                                            name: fieldValueName,
                                            discription: fieldValueDescription,
                                            age: Int16(fieldValueAge)
                                        )
                                        
                                        viewModel.addComment(objectID: image.objectID, fox: fox)
                                    })
                                    TextField("Description...", text: $fieldValueDescription, onCommit: {
                                        let fox = Fox(
                                            name: fieldValueName,
                                            discription: fieldValueDescription,
                                            age: Int16(fieldValueAge)
                                        )
                                        
                                        viewModel.addComment(objectID: image.objectID, fox: fox)
                                    })
                                    TextField("Age...", text: $fieldValueAge, onCommit: {
                                        let fox = Fox(
                                            name: fieldValueName,
                                            discription: fieldValueDescription,
                                            age: Int16(fieldValueAge)
                                        )
                                        
                                        viewModel.addComment(objectID: image.objectID, fox: fox)
                                    })
                                }
                                .focused($nameIsFocused)
                            }
                        }
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 2)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .padding(.horizontal, 16)
        
    }
}
