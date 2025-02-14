//
//  AppointmentView.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import SwiftUI

struct AppointmentView: View {
    @State private var appointments: [Appointment] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(appointments) { appointment in
                    VStack(alignment: .leading) {
                        Text("Pet ID: \(appointment.petId)")
                            .font(.headline)
                        Text("Date: \(appointment.appointmentDate)")
                            .font(.subheadline)
                        if let description = appointment.description {
                            Text("Description: \(description)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    fetchAppointments()
                }
            }
            .navigationTitle("Appointments")
            .onAppear {
                fetchAppointments()
            }
        }
    }

    func fetchAppointments() {
        Task {
            do {
                let databaseService = DatabaseService()
                let query = "SELECT id, pet_id, appointment_date, description FROM appointments;"
                let rows = try databaseService.executeQuery(query)

                // Dönen satırları kontrol edin
                print("Rows: \(rows)")

                // Satırları işlemeye çalışmadan önce mevcut olup olmadığını kontrol edin
                appointments = rows.compactMap { row in
                    // Sütunları doğru formatta alıp almadığımızı kontrol ediyoruz
                    guard let idString = row["id"],
                          let id = Int("\(idString)"),
                          let petIdString = row["pet_id"],
                          let petId = Int("\(petIdString)"),
                          let appointmentDate = row["appointment_date"] as? String else {
                        print("Row parsing failed: \(row)")
                        return nil
                    }

                    let description = row["description"] as? String ?? ""
                    return Appointment(
                        id: id,
                        petId: petId,
                        appointmentDate: appointmentDate,
                        description: description
                    )
                }
            } catch {
                errorMessage = "Failed to fetch appointments: \(error.localizedDescription)"
            }
        }
    }





}

