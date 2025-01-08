import SwiftUI

struct PetManagementView: View {
    @State private var pets: [Pet] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(pets) { pet in
                    VStack(alignment: .leading) {
                        Text(pet.name)
                            .font(.headline)
                        Text("Type: \(pet.type), Age: \(pet.age)")
                            .font(.subheadline)
                        Text("Owner ID: \(pet.ownerId)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .refreshable {
                    fetchPets()
                }
            }
            .navigationTitle("Pets")
            .onAppear {
                fetchPets()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddPetView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func fetchPets() {
        Task {
            do {
                let databaseService = DatabaseService()
                let query = "SELECT id, name, type, age, owner_id FROM pets;"
                
                // `executeQuery` sonucunu bekliyoruz
                let rows = try databaseService.executeQuery(query)
                
                // Ara değişkenler kullanarak `map` işlemini sadeleştiriyoruz
                pets = rows.map { row in
                    let id = row["id"] as? Int ?? 0
                    let name = row["name"] as? String ?? "Unknown"
                    let type = row["type"] as? String ?? "Unknown"
                    let age = row["age"] as? Int ?? 0
                    let ownerId = row["owner_id"] as? Int ?? 0
                    
                    return Pet(
                        id: id,
                        name: name,
                        type: type,
                        age: age,
                        ownerId: ownerId
                    )
                }
            } catch {
                errorMessage = "Failed to fetch pets: \(error.localizedDescription)"
            }
        }
    }



}


