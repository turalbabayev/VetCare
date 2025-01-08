//
//  AddPetView.swift
//  VetCare
//
//  Created by Tural Babayev on 8.01.2025.
//

import SwiftUI

struct AddPetView: View {
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var age: String = ""
    @State private var ownerId: String = ""
    @State private var successMessage: String?
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Pet Details")) {
                TextField("Name", text: $name)
                TextField("Type", text: $type)
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                TextField("Owner ID", text: $ownerId)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: addPet) {
                    Text("Add Pet")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Add Pet")
    }

    func addPet() {
        guard let ageInt = Int(age), let ownerIdInt = Int(ownerId) else {
            errorMessage = "Age and Owner ID must be valid numbers."
            return
        }

        Task {
            do {
                let databaseService = DatabaseService()
                let query = """
                INSERT INTO pets (name, type, age, owner_id)
                VALUES ('\(name)', '\(type)', \(ageInt), \(ownerIdInt));
                """
                _ = try await databaseService.executeQuery(query)
                successMessage = "Pet added successfully!"
                errorMessage = nil
            } catch {
                errorMessage = "Failed to add pet: \(error.localizedDescription)"
            }
        }
    }
}

