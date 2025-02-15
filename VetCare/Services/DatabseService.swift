import PostgresClientKit

class DatabaseService {
    private var configuration: PostgresClientKit.ConnectionConfiguration
    var results: [[String: Any]] = []


    init() {
        configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = "dpg-cu02hs3v2p9s739bpgb0-a.oregon-postgres.render.com"
        configuration.database = "vetcare_3ogy"
        configuration.port = 5432                    // Varsayılan PostgreSQL portu
        configuration.user = "turalbabayev"
        configuration.credential = .md5Password(password: "Y5SYFZTPN1cdJWAbGNHZBbW9sG3ao1yC")
        configuration.ssl = true // SSL bağlantısını devre dışı bırak
    }

    // Veritabanına bağlan ve sorgu çalıştır, sonuçları döndür
    func executeQuery(_ query: String) throws -> [[String: Any]] {
        do {
            print("Starting database connection...")

            // Bağlantıyı oluştur
            let connection = try PostgresClientKit.Connection(configuration: configuration)
            print("Database connection established.")
            defer { connection.close() }

            // Sorguyu hazırla
            print("Preparing statement: \(query)")
            let statement = try connection.prepareStatement(text: query)
            print("Statement prepared.")
            defer { statement.close() }

            // Sorguyu çalıştır
            print("Executing query...")
            let cursor = try statement.execute()
            print("Query executed successfully.")

            // Sonuçları saklayacak dizi
            var results: [[String: Any]] = []

            // Sütun adlarını manuel belirliyoruz
            let columnNames = ["id", "pet_id", "appointment_date", "description"] // Elle belirlenmiş
            print("Using column names: \(columnNames)")

            // Satırları işle
            for row in cursor {
                do {
                    let columns = try row.get().columns
                    print("Row columns: \(columns)")

                    var rowDict: [String: Any] = [:]

                    for (index, column) in columns.enumerated() {
                        guard index < columnNames.count else {
                            print("Index \(index) out of range for column names.")
                            continue
                        }

                        let columnName = columnNames[index]
                        rowDict[columnName] = column
                        print("Mapping \(columnName): \(column)")
                    }

                    print("Row Dict: \(rowDict)")
                    results.append(rowDict) // Sonuçlar dizisine ekle
                } catch {
                    print("Error processing row: \(error)")
                }
            }

            print("Query results: \(results)")
            return results
        } catch {
            print("Error during query execution: \(error)")
            throw error
        }
    }


    // Evcil hayvanları listele (örnek SELECT)
    func listPets() {
        let query = "SELECT name, type, age FROM pets;"
        do {
            print("Listing pets...")
            let pets = try executeQuery(query)
            for pet in pets {
                print("Pet: \(pet)")
            }
        } catch {
            print("Database error: \(error)")
        }
    }

    // Evcil hayvan ekle (örnek INSERT)
    func addPet(name: String, type: String, age: Int, ownerId: Int) {
        let query = """
        INSERT INTO pets (name, type, age, owner_id)
        VALUES ('\(name)', '\(type)', \(age), \(ownerId));
        """
        do {
            print("Adding a new pet...")
            _ = try executeQuery(query)
            print("Pet added successfully!")
        } catch {
            print("Database error: \(error)")
        }
    }

    // Evcil hayvan bilgilerini güncelle (örnek UPDATE)
    func updatePetName(petId: Int, newName: String) {
        let query = """
        UPDATE pets SET name = '\(newName)' WHERE id = \(petId);
        """
        do {
            print("Updating pet name...")
            _ = try executeQuery(query)
            print("Pet updated successfully!")
        } catch {
            print("Database error: \(error)")
        }
    }

    // Evcil hayvanı sil (örnek DELETE)
    func deletePet(petId: Int) {
        let query = """
        DELETE FROM pets WHERE id = \(petId);
        """
        do {
            print("Deleting pet...")
            _ = try executeQuery(query)
            print("Pet deleted successfully!")
        } catch {
            print("Database error: \(error)")
        }
    }
}

enum DatabaseError: Error {
    case metadataUnavailable
}
