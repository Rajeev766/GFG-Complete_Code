//
//  ContentView.swift
//  GFG
//
//  Created by Rajeev Choudhary on 11/10/24.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel = ViewModel()
    let houseName: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.displayedMembers.isEmpty {
                    Text("No members found.")
                        .onAppear {
                            print("No members to display.")
                        }
                } else {
                    ForEach(viewModel.displayedMembers) { member in
                        VStack(spacing: 0) {
                            // Name with yellow background and graduation cap for Hogwarts staff
                            HStack {
                                Text(member.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                // Display graduation cap if the member is part of Hogwarts staff
                                if member.hogwartsStaff {
                                    Image(systemName: "graduationcap.fill")
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)

                            // Centering the image
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: member.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 200)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding(10)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 150, height: 200)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding(10)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 200)

                            // Character details in table format
                            VStack(spacing: 0) {
                                InfoRow(label: "Species", value: member.species)
                                Divider()
                                InfoRow(label: "Gender", value: member.gender)
                                Divider()
                                InfoRow(label: "House", value: member.house, backgroundColor: houseColor(for: member.house))
                                Divider()
                                InfoRow(label: "Date of Birth", value: formatDate(member.dateOfBirth ?? "Unknown"))
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                        }
                        .background(Color.gray.opacity(0.2)) // Slight background color for card effect
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    // "Next Page" button
                    if viewModel.displayedMembers.count < viewModel.members.count {
                        Button(action: {
                            viewModel.loadMoreMembers()
                        }) {
                            Text("Next Page")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMembers(for: houseName)
        }
        .refreshable {
            viewModel.resetPagination()
            viewModel.fetchMembers(for: houseName)
        }
        .navigationTitle(houseName)
    }
    
    // Helper function to format the date as "31 July, 1980"
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy" // This is the format in the JSON
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM, yyyy" // Desired format: "31 July, 1980"
            return outputFormatter.string(from: date)
        }
        
        return dateString // Return original string if parsing fails
    }
    
    // Helper function to return the house color based on house name (without opacity)
    func houseColor(for house: String) -> Color {
        switch house {
        case "Gryffindor":
            return Color.red
        case "Slytherin":
            return Color.green
        case "Ravenclaw":
            return Color.blue
        case "Hufflepuff":
            return Color.yellow
        default:
            return Color.clear
        }
    }
}

// Custom view for information rows
struct InfoRow: View {
    let label: String
    let value: String
    var backgroundColor: Color? = nil
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .background(backgroundColor ?? Color.gray)
                .cornerRadius(5)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
