-- Pet Tablosu
CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 0),
    owner_id INT NOT NULL
);

-- Owner Tablosu
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(150)
);

-- Appointments Tablosu
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    pet_id INT NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    description TEXT
);

-- Treatments Tablosu
CREATE TABLE treatments (
    id SERIAL PRIMARY KEY,
    pet_id INT NOT NULL REFERENCES pets(id) ON DELETE CASCADE,
    treatment_date DATE NOT NULL,
    treatment_type VARCHAR(100),
    cost NUMERIC(10, 2) CHECK (cost >= 0)
);

-- View Oluşturma
CREATE VIEW pet_appointments AS
SELECT p.name AS pet_name, o.name AS owner_name, a.appointment_date, a.description
FROM pets p
JOIN owners o ON p.owner_id = o.id
JOIN appointments a ON a.pet_id = p.id;

-- Sequence Oluşturma
CREATE SEQUENCE treatment_sequence
START 1
INCREMENT 1;

-- Örnek Veriler Ekleme
INSERT INTO owners (name, contact_info) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Mike Brown', 'mike.brown@example.com'),
('Anna White', 'anna.white@example.com'),
('Tom Black', 'tom.black@example.com'),
('Lisa Green', 'lisa.green@example.com'),
('James Blue', 'james.blue@example.com'),
('Emma Gray', 'emma.gray@example.com'),
('Chris Red', 'chris.red@example.com'),
('Sara Pink', 'sara.pink@example.com');

INSERT INTO pets (name, type, age, owner_id) VALUES
('Buddy', 'Dog', 3, 1),
('Mittens', 'Cat', 2, 2),
('Charlie', 'Bird', 4, 3),
('Max', 'Dog', 5, 4),
('Lucy', 'Cat', 1, 5),
('Bella', 'Dog', 6, 6),
('Daisy', 'Rabbit', 3, 7),
('Rocky', 'Fish', 1, 8),
('Luna', 'Cat', 2, 9),
('Simba', 'Dog', 4, 10);

INSERT INTO appointments (pet_id, appointment_date, description) VALUES
(1, '2025-01-10', 'Annual Checkup'),
(2, '2025-01-15', 'Vaccination'),
(3, '2025-01-20', 'Wing Trimming'),
(4, '2025-01-25', 'Dental Cleaning'),
(5, '2025-02-01', 'Spaying Surgery'),
(6, '2025-02-05', 'Hip Dysplasia Treatment'),
(7, '2025-02-10', 'Vaccination'),
(8, '2025-02-15', 'Water Quality Check'),
(9, '2025-02-20', 'Flea Treatment'),
(10, '2025-02-25', 'Vaccination');

INSERT INTO treatments (pet_id, treatment_date, treatment_type, cost) VALUES
(1, '2025-01-11', 'Vaccination', 50.00),
(2, '2025-01-16', 'Deworming', 30.00),
(3, '2025-01-21', 'General Checkup', 40.00),
(4, '2025-01-26', 'X-ray', 100.00),
(5, '2025-02-02', 'Spaying Surgery', 300.00),
(6, '2025-02-06', 'Physiotherapy', 150.00),
(7, '2025-02-11', 'Vaccination', 50.00),
(8, '2025-02-16', 'Filter Replacement', 20.00),
(9, '2025-02-21', 'Flea Treatment', 60.00),
(10, '2025-02-26', 'Vaccination', 50.00);

-- Fonksiyonlar
CREATE OR REPLACE FUNCTION get_pet_appointments(pet_name VARCHAR) RETURNS TABLE(owner_name VARCHAR, appointment_date DATE, description TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT o.name, a.appointment_date, a.description
    FROM pets p
    JOIN owners o ON p.owner_id = o.id
    JOIN appointments a ON a.pet_id = p.id
    WHERE p.name = pet_name;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_total_treatment_costs(pet_id INT) RETURNS NUMERIC AS $$
DECLARE
    total_cost NUMERIC;
BEGIN
    SELECT SUM(cost) INTO total_cost FROM treatments WHERE treatments.pet_id = pet_id;
    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_upcoming_appointments(days_ahead INT) RETURNS SETOF appointments AS $$
BEGIN
    RETURN QUERY SELECT * FROM appointments WHERE appointment_date <= CURRENT_DATE + days_ahead;
END;
$$ LANGUAGE plpgsql;

-- Triggerlar
CREATE OR REPLACE FUNCTION log_treatment() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Treatment for pet % on % has been logged.', NEW.pet_id, NEW.treatment_date;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER treatment_logger
AFTER INSERT ON treatments
FOR EACH ROW EXECUTE FUNCTION log_treatment();

CREATE OR REPLACE FUNCTION prevent_delete_owner_with_pets() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM pets WHERE owner_id = OLD.id) THEN
        RAISE EXCEPTION 'Cannot delete owner with associated pets.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER owner_delete_preventer
BEFORE DELETE ON owners
FOR EACH ROW EXECUTE FUNCTION prevent_delete_owner_with_pets();
