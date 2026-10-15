CREATE TABLE Patient_information
(
    Patient_id INT PRIMARY KEY NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    NHS_number VARCHAR(20) UNIQUE,
    address VARCHAR(100),
    postcode VARCHAR(10),
    telephone_number VARCHAR(15),
    known_allergies VARCHAR(255),
    prescription_charge_exemption_category VARCHAR(50)
)
CREATE TABLE Prescriber_information
(
    Prescriber_id INT PRIMARY KEY NOT NULL UNIQUE,
    prescriber_name VARCHAR(100),
    prescriber_type VARCHAR(25),
    practice_name VARCHAR(100),
    practice_address VARCHAR(100),
    practice_code INT,
    professional_registration_number VARCHAR(20) UNIQUE
)
CREATE TABLE Medication_details
(
    medicatiion_name VARCHAR(100) NOT NULL PRIMARY KEY,
    brand_name VARCHAR(100), 
    strength VARCHAR(50),
    form VARCHAR(50),
    quantity INT,
    directions_for_use VARCHAR(255),
    number_of_repeats_authorised INT,
    medication_controlled BOOLEAN,
)
CREATE TABLE Dispensing_information
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    date_prescribed DATE,
    date_dispensed DATE,
    date_collected DATE,
    branch VARCHAR(100),
    dispensing_pharmacist VARCHAR(3) NOT NULL CHECK (dispensing_pharmacist IN ('pending', 'dispensed', 'collected', 'cancelled')),
    charge_status VARCHAR(3) NOT NULL CHECK (charge_status IN ('paid','exempt')),
)
/*CREATE TABLE Prescription_status
(
    pending BOOLEAN,
    dispensed BOOLEAN,
    collected BOOLEAN,
    cancelled BOOLEAN,
)
CREATE TABLE Medication_form
(
    tablet BOOLEAN,
    capsule BOOLEAN,
)*/