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
    @State private var isEdit = false
    @State private var showAlert = false
    
    @FocusState private var nameIsFocused: Bool
    
    var image: FoxImage = FoxImage()
    
    init(
        imageStorage: ImageStorage,
        fieldValueName: String,
        image: FoxImage,
        fieldValueDescription: String,
        fieldValueAge: String
    ) {
        _viewModel = StateObject(wrappedValue: SpecificViewModel(imageStorage: imageStorage))
        self.image = image
        self.fieldValueName = fieldValueName
        self.fieldValueDescription = fieldValueDescription
        self.fieldValueAge = fieldValueAge
    }
    
    private func dateAndTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
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
                        
                        //Дата добавления в избранное
                        if let dateFox = image.date {
                            Text ("\(dateAndTime(dateFox))")
                                .foregroundColor(.gray)
                        }
                        
                        Text("Your comment:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 32)
                        
                        //Комментарий
                        HStack {
                            if
                                let name = image.name,
                                let discription = image.discription
                            {
                                
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
                                        
                                        Text("\(name)\n\(discription)\n\(image.age)")
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
        .toolbar {
            Button {
                viewModel.delete(image: image)
                    showAlert = true
                
            } label: {
                Label("", systemImage: "trash")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Delete"),
                      message: Text("Image removed"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
