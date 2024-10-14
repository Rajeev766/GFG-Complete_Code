//
//  ContentView.swift
//  GFG
//
//  Created by Rajeev Choudhary on 11/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text("HOUSES")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, geometry.size.height * 0.05)

                    Spacer()

                    // First Row
                    HStack {
                        houseButton(imageName: "Gryffindor", houseName: "Gryffindor", width: geometry.size.width * 0.4)

                        houseButton(imageName: "Slytherin", houseName: "Slytherin", width: geometry.size.width * 0.4)
                    }
                    .padding()

                    Spacer()

                    // Second Row
                    HStack {
                        houseButton(imageName: "Ravenclaw", houseName: "Ravenclaw", width: geometry.size.width * 0.4)

                        houseButton(imageName: "Hufflepuff", houseName: "Hufflepuff", width: geometry.size.width * 0.4)
                    }
                    .padding()

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures view fills screen
            }
        }
    }

    private func houseButton(imageName: String, houseName: String, width: CGFloat) -> some View {
        NavigationLink(destination: CharacterListView(houseName: houseName)) { // Navigate to CharacterListView
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: width) // Scales the image based on device width

                Text(houseName)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(width: width, height: width + 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone") // Specify device for preview

            ContentView()
                .previewDevice("iPad") // Specify iPad for preview
        }
    }
}
