//
//  ContentView.swift
//  GFG
//
//  Created by Rajeev Choudhary on 11/10/24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var members: [Character] = []
    @Published var displayedMembers: [Character] = []

    private var currentPage = 1
    private let pageSize = 10

    func fetchMembers(for house: String) {
        guard let url = URL(string: "https://hp-api.herokuapp.com/api/characters/house/\(house)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let fetchedMembers = try JSONDecoder().decode([Character].self, from: data)
                DispatchQueue.main.async {
                    self?.members = fetchedMembers
                    self?.resetPagination()
                    self?.loadMoreMembers()
                }
            } catch {
                print("Failed to decode data: \(error)")
            }
        }
        task.resume()
    }

    func loadMoreMembers() {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(currentPage * pageSize, members.count)

        if startIndex < endIndex {
            let newMembers = members[startIndex..<endIndex]
            displayedMembers.append(contentsOf: newMembers)
            currentPage += 1
        }
    }

    func resetPagination() {
        displayedMembers.removeAll()
        currentPage = 1
    }
}

struct Character: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let species: String
    let gender: String
    let house: String
    let dateOfBirth: String?
    let image: String
    let hogwartsStaff: Bool
}
