//
//  ContentView.swift
//  Image
//
//  Created by Elizaveta on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    private let url = URL(string: "https://cs8.pikabu.ru/post_img/big/2016/02/04/7/145458292112119207.jpg")
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            
            ZStack{
                AsyncImage(url: url)
                    .frame(width: 70, height: 900, alignment: .top)

                Button(action: {
                    print("изменение")
                }, label: {
                    Text("Change image")
                        .font(.title)
                        .padding()
                        .background(Color.pink)
                        .foregroundStyle(.white)
                        .cornerRadius(40)
                        .padding()
                        .padding(-2)
                        .overlay {
                            RoundedRectangle(cornerRadius: 45)
                                .stroke(.pink, lineWidth: 5)
                        }
                })
                .frame(width: 250, height: 600, alignment: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}
