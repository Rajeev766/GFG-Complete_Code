//
//  ContentView.swift
//  GFG
//
//  Created by Rajeev Choudhary on 11/10/24.
//

import SwiftUI

struct TableRowView: View {
    let label: String
    let value: String
    var backgroundColor: Color? = nil
    var foregroundColor: Color = .black

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )

            Text(value)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(backgroundColor ?? Color.white)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .frame(height: 50)
    }
}

struct CharacterListView: View {
    @StateObject var viewModel = ViewModel()
    let houseName: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.displayedMembers.isEmpty {
                    Text("No members found.")
                } else {
                    ForEach(viewModel.displayedMembers) { member in
                        VStack(spacing: 10) {
                            VStack(spacing: 0) {
                                HStack {
                                    Text(member.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    if member.hogwartsStaff {
                                        Image(systemName: "graduationcap.fill")
                                            .foregroundColor(.black)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)

                                HStack {
                                    Spacer()
                                    AsyncImage(url: URL(string: member.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 200)
                                            .cornerRadius(10)
                                            .padding(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 150, height: 200)
                                            .cornerRadius(10)
                                            .padding(10)
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)

                                VStack(spacing: 0) {
                                    TableRowView(label: "Species", value: member.species)
                                    TableRowView(label: "Gender", value: member.gender)
                                    TableRowView(label: "House", value: member.house, backgroundColor: houseColor(for: member.house), foregroundColor: .white)
                                    TableRowView(label: "Date of Birth", value: formatDate(member.dateOfBirth ?? "Unknown"))
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
                            .padding(10)
                        }
                        .background(Color.clear)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }

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

    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM, yyyy"
            return outputFormatter.string(from: date)
        }
        return dateString
    }

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
