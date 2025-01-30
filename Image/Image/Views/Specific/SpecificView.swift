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
    
    @State var fieldValue: String
    
    var image: FoxImage = FoxImage()
    
    init(imageStorage: ImageStorage, fieldValue: String, image: FoxImage) {
        self.fieldValue = fieldValue
        _viewModel = StateObject(wrappedValue: SpecificViewModel(imageStorage: imageStorage))
        self.image = image
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let imageData = image.data, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 4)
                        }
                        .padding(16)
                }
                
                if let comment = image.comment {
                    Text(comment)
                        .padding()
                    
                } else {
                    
                    HStack {
                        
                        TextField("Leave a comment", text: $fieldValue)
                        Button {
                            viewModel.addComment(text: fieldValue, objectID: NSManagedObjectID())
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
                    .padding(16)
                }
                    
            }
            .padding(16)
        }
    }
}
