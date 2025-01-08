//
//  Owner.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import Foundation

struct Owner: Identifiable, Codable {
    let id: Int
    var name: String
    var contactInfo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case contactInfo = "contact_info"
    }
}
