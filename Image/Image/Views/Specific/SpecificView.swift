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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FoxImage.uuid, ascending: true)], animation: .default)
    private var images: FetchedResults<FoxImage>
    
    init(imageStorage: ImageStorage, fieldValue: String) {
        self.fieldValue = fieldValue
        _viewModel = StateObject(wrappedValue: SpecificViewModel(imageStorage: imageStorage))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    TextField("Leave a comment", text: $fieldValue)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.horizontal)
                    ForEach(images, id: \.self) { image in
                        if let data = image.data {
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                            }
                        }
                    }
                }
            }
        }
        
    }
}
