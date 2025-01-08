//
//  Appointment.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import Foundation

struct Appointment: Identifiable, Codable {
    let id: Int
    var petId: Int
    var appointmentDate: String
    var description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case petId = "pet_id"
        case appointmentDate = "appointment_date"
        case description
    }
}

