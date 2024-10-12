//
//  ContentView.swift
//  GFG
//
//  Created by Rajeev Choudhary on 11/10/24.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var members: [HouseMember] = [] // All members fetched from the API
    @Published var displayedMembers: [HouseMember] = [] // Members currently displayed
    let itemsPerPage = 10 // Limit per page
    private var currentPage = 0 // Track the current page
    private var totalMembers: Int {
        members.count // Total number of members
    }

    // Fetch members for a specific house and page
    func fetchMembers(for houseName: String, page: Int = 0) {
        let urlString = "https://hp-api.herokuapp.com/api/characters/house/\(houseName)"
        print("Fetching members for house: \(houseName) - Page: \(page + 1)")

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Decode to an array of HouseMember
                let allMembers = try JSONDecoder().decode([HouseMember].self, from: data)
                DispatchQueue.main.async {
                    self.members = allMembers // Store all members
                    self.loadMoreMembers() // Load the first page of members
                }
            } catch {
                print("Error decoding data: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON data: \(jsonString)")
                }
            }
        }.resume()
    }

    // Load more members based on current page
    func loadMoreMembers() {
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, totalMembers)

        if startIndex < totalMembers {
            displayedMembers.append(contentsOf: Array(members[startIndex..<endIndex]))
            currentPage += 1 // Move to the next page
        }
    }

    func resetPagination() {
        displayedMembers.removeAll()
        currentPage = 0
    }
}


import Foundation

struct HouseMember: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let species: String
    let gender: String
    let house: String
    let dateOfBirth: String?
    let image: String
    let alternate_names: [String]
    let hogwartsStaff: Bool
}
