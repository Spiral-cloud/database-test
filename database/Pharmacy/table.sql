CREATE DATABASE IF NOT EXISTS Pharmacy;
USE Pharmacy;
CREATE ROLE IF NOT EXISTS pharmacist;
CREATE ROLE IF NOT EXISTS dispensing_assistant;
CREATE ROLE IF NOT EXISTS branch_manager;
CREATE ROLE IF NOT EXISTS head_office_administrator;
CREATE ROLE IF NOT EXISTS prescriber;
CREATE ROLE IF NOT EXISTS patient;
CREATE TABLE IF NOT EXISTS Patient_information COMMENT 'This table stores all of the necessary patient information'
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
    prescription_charge_exemption_category ENUM('under 16', 'aged 16 to 18 and in full time education', 'aged 60 or over', 'maternity exemption', 'medical exemption', 'prepayment certificate', 'none, charge paid')
);
CREATE TABLE IF NOT EXISTS Prescriber_information COMMENT 'This table stores all of the necessary prescriber information'
(
    Prescriber_id INT PRIMARY KEY NOT NULL UNIQUE,
    prescriber_name VARCHAR(100),
    prescriber_type enum('GP', 'nurse prescriber', 'pharmacist prescriber', 'hospital consultant', 'dentist') NOT NULL,
    practice_name VARCHAR(100),
    practice_address VARCHAR(100),
    practice_code INT,
    professional_registration_number VARCHAR(20) UNIQUE
);
CREATE TABLE IF NOT EXISTS Medication_details COMMENT 'This table stores all of the necessary medication details'
(
    medication_id INT PRIMARY KEY NOT NULL UNIQUE,
    medication_name VARCHAR(100) NOT NULL,
    brand_name VARCHAR(100), 
    strength VARCHAR(50),
    form enum('tablet', 'capsule', 'liquid') NOT NULL,
    quantity INT,
    directions_for_use VARCHAR(255),
    number_of_repeats_authorised INT,
    medication_controlled enum('yes', 'no') NOT NULL
);
CREATE TABLE IF NOT EXISTS Dispensing_information COMMENT 'This table stores all of the necessary dispensing information as well as assigning foreign keys to relate to other tables'
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    date_prescribed DATE NOT NULL,
    date_dispensed DATE,
    date_collected DATE,
    branch VARCHAR(100),
    --dispensing_pharmacist VARCHAR(3) NOT NULL CHECK (dispensing_pharmacist IN ('pending', 'dispensed', 'collected', 'cancelled')),
    dispensing_pharmacist enum('pending', 'dispensed', 'collected', 'cancelled') NOT NULL,
    --charge_status VARCHAR(3) NOT NULL CHECK (charge_status IN ('paid','exempt')),
    charge_status enum('paid','exempt') NOT NULL,
    number_of_repeats_remaining INT,
    prescriber_id INT NOT NULL,
    patient_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    number_of_repeats_authorised INT NOT NULL DEFAULT 0,
    FOREIGN KEY (prescriber_id) REFERENCES Prescriber_information(Prescriber_id),
    FOREIGN KEY (patient_id) REFERENCES Patient_information(Patient_id),
    FOREIGN KEY (medication_name) REFERENCES Medication_details(medication_name),
    CONSTRAINT fk_Prescription_id UNIQUE (Prescription_id),
    CONSTRAINT dispensing_after_prescription CHECK ( date_dispensed IS NULL OR date_dispensed >= date_prescribed),
    CONSTRAINT collection_after_dispensing CHECK (date_collected IS NULL OR date_collected >= date_dispensed)
    CONSTRAINT repeats_not_above_authorised CHECK (number_of_repeats_authorised <= number_of_repeats_remaining)
);
CREATE TABLE IF NOT EXISTS Prescription_status COMMENT 'this table stores the status of the prescription and is updates the status of the prescription in the dispensing_information table'
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    status enum('pending', 'dispensed', 'collected', 'cancelled') NOT NULL,
    FOREIGN KEY (Prescription_id) REFERENCES Dispensing_information(Prescription_id)
    /*pending BOOLEAN,
    dispensed BOOLEAN,
    collected BOOLEAN,
    cancelled BOOLEAN,*/
);
INSERT INTO Prescription_status (Prescription_id) values (1, 'pending', 'dispensed', 'collected', 'cancelled');
CREATE TABLE IF NOT EXISTS Medication_form COMMENT 'This table stores the form of the medication'
(
    Medication_id INT PRIMARY KEY NOT NULL UNIQUE,
    Medication_form enum('tablet', 'capsule', 'liquid') NOT NULL,
    FOREIGN KEY (Medication_id) REFERENCES Medication_details(medication_name)
    /*tablet BOOLEAN,
    capsule BOOLEAN,*/
);
INSERT INTO Medication_form (Medication_id) values (1, 'tablet', 'capsule', 'liquid');
CREATE TABLE IF NOT EXISTS Prescriber_type COMMENT 'This table stores the type of prescriber'
(
    Prescriber_id INT PRIMARY KEY NOT NULL UNIQUE, 
    Prescriber_type enum('GP', 'nurse prescriber', 'pharmacist prescriber', 'hospital consultant', 'dentist') NOT NULL,
    FOREIGN KEY (Prescriber_id) REFERENCES Prescriber_information(Prescriber_id)
   /* nurse_prescriber BOOLEAN,
    pharmacist_prescriber BOOLEAN,
    hospital_consultant BOOLEAN,
    dentist BOOLEAN,*/
);
INSERT INTO Prescriber_type (Prescriber_id) VALUES (1, 'GP', 'nurse prescriber', 'pharmacist prescriber', 'hospital consultant', 'dentist');
CREATE TABLE IF NOT EXISTS Prescription_charge_exemption_category COMMENT 'This table stores the prescription charge exemption category of the patient'
(
    Patient_id INT PRIMARY KEY NOT NULL UNIQUE,
    Prescription_charge_exemption_category enum('under 16', 'aged 16 to 18 and in full time education', 'aged 60 or over', 'maternity exemption', 'medical exemption', 'prepayment certificate', 'none, charge paid') NOT NULL,
    FOREIGN KEY (Patient_id) REFERENCES Patient_information(Patient_id)
    /*under_16 BOOLEAN,
    aged_16_to_18_and_in_full_time_education BOOLEAN,
    aged_60_or_over BOOLEAN,
    maternity_exemption BOOLEAN,
    medical_exemption BOOLEAN,
    prepayment_certificate BOOLEAN,
    none_charge_paid BOOLEAN,*/
);
INSERT INTO Prescription_charge_exemption_category (Patient_id) values (1, 'under 16', 'aged 16 to 18 and in full time education', 'aged 60 or over', 'maternity exemption', 'medical exemption', 'prepayment certificate', 'none, charge paid');
CREATE TABLE IF NOT EXISTS Medication_controlled COMMENT 'This table stores the controlled status of the medication'
(
    Medication_id INT PRIMARY KEY NOT NULL UNIQUE,
    Medication_controlled enum('yes', 'no') NOT NULL,
    FOREIGN KEY (Medication_id) REFERENCES Medication_details(medication_name)
    /*yes BOOLEAN,
    no BOOLEAN,*/
);
INSERT INTO Medication_controlled (Medication_id) VALUES (1, 'yes', 'no'); 
CREATE TABLE IF NOT EXISTS Staff_roles COMMENT 'This table stores the roles of the staff members'
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    role enum('pharmacist', 'dispensing_assistant', 'branch_manager', 'head_office_administrator') NOT NULL,
    FOREIGN KEY (Prescription_id) REFERENCES Dispensing_information(Prescription_id)
    /*dispensing_pharmacist BOOLEAN,
    prescriber BOOLEAN,*/
);
INSERT INTO Patient_information (Patient_id, first_name, last_name, date_of_birth, NHS_number, address, postcode, telephone_number, known_allergies, prescription_charge_exemption_category) VALUES (1, 'John', 'Doe', '1990-01-01', '1234567890', '123 Main St', 'AB12 3CD', '01234567890', 'Penicillin', 'none, charge paid');
SELECT p.patient_id, p.first_name, p.last_name, p.date_of_birth, p.NHS_number, p.address, p.postcode, p.telephone_number, p.known_allergies, p.prescription_charge_exemption_category
FROM Patient_information p
JOIN Dispensing_information d ON p.patient_id = d.patient_id
JOIN Medication_details m ON d.medication_id = m.medication_id
WHERE p.known_allergies IS NOT NULL AND p.known_allergies <> 'None'; AND FIND_IN_SET(LOWER(m.medication_name), REPLACE(LOWER(p.known_allergies), ', ', ',')) > 0;
INSERT INTO Staff_roles (Prescription_id) VALUES (1, 'pharmacist', 'dispensing_assistant', 'branch_manager', 'head office administrator');
/*CREATE RULE IF NOT EXISTS Unique_identifier AS ON INSERT TO Prescription_status
    WHERE EXISTS (SELECT 1 FROM Prescription_status WHERE Prescription_id = NEW.Prescription_id)
    DO INSTEAD NOTHING;*/
GRANT SELECT, INSERT, UPDATE ON Pharmacy.Dispensing_information TO pharmacist;
GRANT SELECT ON Pharmacy.Dispensing_information TO dispensing_assistant;
GRANT SELECT, INSERT, DELETE, UPDATE ON Pharmacy.Dispensing_information TO branch_manager;
GRANT SELECT, INSERT, DELETE, UPDATE ON Pharmacy.* TO head_office_administrator;
GRANT SELECT ON Pharmacy.Prescriber_information TO prescriber;
GRANT SELECT ON Pharmacy.Dispensing_information TO patient;
CREATE USER IF NOT EXISTS 'pharmacist' IDENTIFIED BY 'pharmacist_password';
CREATE USER IF NOT EXISTS 'dispensing_assistant' IDENTIFIED BY 'dispensing_assistant_password';
CREATE USER IF NOT EXISTS 'branch_manager' IDENTIFIED BY 'branch_manager_password';
CREATE USER IF NOT EXISTS 'head_office_administrator' IDENTIFIED BY 'head_office_administrator_password';
CREATE USER IF NOT EXISTS 'prescriber' IDENTIFIED BY 'prescriber_password';
CREATE USER IF NOT EXISTS 'prescriber_2' IDENTIFIED BY 'prescriber_password2';
CREATE USER IF NOT EXISTS 'prescriber_3' IDENTIFIED BY 'prescriber_password3';
CREATE USER IF NOT EXISTS 'prescriber_4' IDENTIFIED BY 'prescriber_password4';
CREATE USER IF NOT EXISTS 'prescriber_5' IDENTIFIED BY 'prescriber_password2';
CREATE USER IF NOT EXISTS 'patient' IDENTIFIED BY 'patient_password';
CREATE USER IF NOT EXISTS 'patient_2' IDENTIFIED BY 'patient_password2';
CREATE USER IF NOT EXISTS 'patient_3' IDENTIFIED BY 'patient_password3';
CREATE USER IF NOT EXISTS 'patient_4' IDENTIFIED BY 'patient_password4';
CREATE USER IF NOT EXISTS 'patient_5' IDENTIFIED BY 'patient_password5';
CREATE USER IF NOT EXISTS 'patient_6' IDENTIFIED BY 'patient_password6';
CREATE USER IF NOT EXISTS 'patient_7' IDENTIFIED BY 'patient_password7';
CREATE USER IF NOT EXISTS 'patient_8' IDENTIFIED BY 'patient_password8';
CREATE USER IF NOT EXISTS 'patient_9' IDENTIFIED BY 'patient_password9';
CREATE USER IF NOT EXISTS 'patient_10' IDENTIFIED BY 'patient_password10';
CREATE USER IF NOT EXISTS 'patient_11' IDENTIFIED BY 'patient_password11';
CREATE USER IF NOT EXISTS 'patient_12' IDENTIFIED BY 'patient_password12';
CREATE USER IF NOT EXISTS 'patient_13' IDENTIFIED BY 'patient_password13';
CREATE USER IF NOT EXISTS 'patient_14' IDENTIFIED BY 'patient_password14';
CREATE USER IF NOT EXISTS 'patient_15' IDENTIFIED BY 'patient_password15';
GRANT pharmacist TO 'pharmacist';
GRANT dispensing_assistant TO 'dispensing_assistant';
GRANT branch_manager TO 'branch_manager';
GRANT head_office_administrator TO 'head_office_administrator';
GRANT prescriber TO 'prescriber' && 'prescriber_2' && 'prescriber_3' && 'prescriber_4' && 'prescriber_5';
GRANT patient TO 'patient' && 'patient_2' && 'patient_3' && 'patient_4' && 'patient_5';
