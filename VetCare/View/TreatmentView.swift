//
//  TreatmentView.swift
//  VetCare
//
//  Created by Tural Babayev on 7.01.2025.
//

import SwiftUI

struct TreatmentView: View {
    @State private var treatments: [Treatment] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(treatments) { treatment in
                    VStack(alignment: .leading) {
                        Text("Pet ID: \(treatment.petId)")
                            .font(.headline)
                        Text("Date: \(treatment.treatmentDate)")
                            .font(.subheadline)
                        Text("Type: \(treatment.treatmentType)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Cost: \(treatment.cost, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    fetchTreatments()
                }
            }
            .navigationTitle("Treatments")
            .onAppear {
                fetchTreatments()
            }
        }
    }

    func fetchTreatments() {
        Task {
            do {
                let databaseService = DatabaseService()
                let query = "SELECT id, pet_id, treatment_date, treatment_type, cost FROM treatments;"
                
                // `executeQuery` metodunu çağırarak sonuçları alıyoruz
                let rows = try databaseService.executeQuery(query)
                
                // `rows` üzerindeki işlemleri düzenliyoruz
                treatments = rows.map { row in
                    let id = row["id"] as? Int ?? 0
                    let petId = row["pet_id"] as? Int ?? 0
                    let treatmentDate = row["treatment_date"] as? String ?? "Unknown"
                    let treatmentType = row["treatment_type"] as? String ?? "Unknown"
                    let cost = row["cost"] as? Double ?? 0.0
                    
                    return Treatment(
                        id: id,
                        petId: petId,
                        treatmentDate: treatmentDate,
                        treatmentType: treatmentType,
                        cost: cost
                    )
                }
            } catch {
                // Hata durumunda kullanıcıya anlamlı bir mesaj iletilir
                errorMessage = "Failed to fetch treatments: \(error.localizedDescription)"
            }
        }
    }



}
