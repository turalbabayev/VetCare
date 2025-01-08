//
//  Treatment.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import Foundation

struct Treatment: Identifiable, Codable {
    let id: Int
    var petId: Int
    var treatmentDate: String
    var treatmentType: String
    var cost: Double

    enum CodingKeys: String, CodingKey {
        case id
        case petId = "pet_id"
        case treatmentDate = "treatment_date"
        case treatmentType = "treatment_type"
        case cost
    }
}

