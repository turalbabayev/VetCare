//
//  Pet.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import Foundation

struct Pet: Identifiable, Codable {
    let id: Int
    var name: String
    var type: String
    var age: Int
    var ownerId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case age
        case ownerId = "owner_id"
    }
}
