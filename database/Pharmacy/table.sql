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
    medication_id INT NOT NULL,
    number_of_repeats_authorised INT NOT NULL DEFAULT 0,
    FOREIGN KEY (prescriber_id) REFERENCES Prescriber_information(Prescriber_id),
    FOREIGN KEY (patient_id) REFERENCES Patient_information(Patient_id),
    FOREIGN KEY (medication_id) REFERENCES Medication_details(medication_id),
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
INSERT INTO Patient_information (Patient_id, first_name, last_name, date_of_birth, NHS_number, address, postcode, telephone_number, known_allergies, prescription_charge_exemption_category) VALUES (
    1, 'John', 'Doe', '1990-01-01', '1234567890', '123 Main St', 'AB12 3CD', '01234567890', 'Penicillin', 'none, charge paid'
    2, 'Jane', 'Smith', '1985-05-15', '0987654321', '456 Elm St', 'EF45 6GH', '0987654321', 'None', 'medical exemption'
    3, 'Alice', 'Johnson', '2000-10-20', '5678901234', '789 Oak St', 'IJ78 9KL', '5678901234', 'Aspirin, Ibuprofen', 'under 16'
    4, 'Bob', 'Williams', '1975-03-30', '3456789012', '321 Pine St', 'MN12 3OP', '3456789012', 'None', 'aged 60 or over'
    5, 'Charlie', 'Brown', '1995-07-10', '  2345678901', '654 Cedar St', 'QR45 6ST', '2345678901', 'None', 'prepayment certificate'
    6, 'David', 'Jones', '1980-12-25', '4567890123', '987 Birch St', 'UV78 9WX', '4567890123', 'None', 'maternity exemption'
    7, 'Eve', 'Davis', '1998-09-05', '6789012345', '135 Maple St', 'YZ12 3AB', '6789012345', 'None', 'aged 16 to 18 and in full time education'
    8, 'Frank', 'Miller', '1970-11-15', '8901234567', '246 Spruce St', 'CD45 6EF', '8901234567', 'None', 'medical exemption'
    9, 'Grace', 'Wilson', '2002-02-28', '0123456789', '357 Willow St', 'GH78 9IJ', '0123456789', 'None', 'none, charge paid'
    10, 'Hannah', 'Moore', '1992-06-18', '2345678901', '468 Aspen St', 'KL12 3MN', '2345678901', 'None', 'prepayment certificate'
    11, 'Ian', 'Taylor', '1988-04-12', '3456789012', '579 Poplar St', 'OP45 6QR', '3456789012', 'None', 'aged 60 or over'
    12, 'Jack', 'Anderson', '1993-08-22', '4567890123', '680 Chestnut St', 'ST78 9UV', '4567890123', 'None', 'under 16'
    13, 'Kathy', 'Thomas', '1983-01-30', '5678901234', '791 Walnut St', 'WX12 3YZ', '5678901234', 'None', 'maternity exemption'
    14, 'Leo', 'Jackson', '1996-05-14', '6789012345', '802 Fir St', 'YZ45 6AB', '6789012345', 'None', 'aged 16 to 18 and in full time education'
    15, 'Mia', 'White', '1987-09-09', '7890123456', '913 Redwood St', 'AB78 9CD', '7890123456', 'None', 'medical exemption'
    );
SELECT p.patient_id, p.first_name, p.last_name, p.date_of_birth, p.NHS_number, p.address, p.postcode, p.telephone_number, p.known_allergies, p.prescription_charge_exemption_category
FROM Patient_information p
JOIN Dispensing_information d ON p.patient_id = d.patient_id
JOIN Medication_details m ON d.medication_id = m.medication_id
WHERE p.known_allergies IS NOT NULL AND p.known_allergies <> 'None'; AND FIND_IN_SET(LOWER(m.medication_name), REPLACE(LOWER(p.known_allergies), ', ', ',')) > 0;
INSERT INTO Prescriber_information (Prescriber_id, prescriber_name, prescriber_type, practice_name, practice_address, practice_code, professional_registration_number) VALUES (
    1, 'Dr. Smith', 'GP', 'Smith Medical Practice', 'Main Branch', 12345, 'REG123456'
    2, 'Nurse Johnson', 'nurse prescriber', 'Market Branch', '456 Elm St', 67890, 'REG234567'
    3, 'Pharmacist Brown', 'pharmacist prescriber', 'Main Branch', '789 Oak St', 54321, 'REG345678'
    4, 'Dr. Lee', 'hospital consultant', 'Lee Hospital', 'High Street Branch', 98765, 'REG456789'
    5, 'Dr. Patel', 'dentist', 'Patel Dental Clinic', 'Main Branch', 13579, 'REG567890'
    );
INSERT INTO Medication_details (medication_id, medication_name, brand_name, strength, form, quantity, directions_for_use, number_of_repeats_authorised, medication_controlled) VALUES (
    1, 'Amoxicillin', 'Amoxil', '500mg', 'capsule', 30, 'Take one capsule three times a day for 7 days', 0, 'no'
    2, 'Ibuprofen', 'Nurofen', '200mg', 'tablet', 20, 'Take one tablet every 6 hours as needed for pain', 0, 'no'
    3, 'Paracetamol', 'Panadol', '500mg', 'tablet', 16, 'Take one tablet every 4-6 hours as needed for pain or fever', 0, 'no'
    4, 'Salbutamol Inhaler', 'Ventolin', NULL, 'liquid', 1, 'Inhale two puffs every 4-6 hours as needed for wheezing or shortness of breath', 0, 'no'
    5, 'Metformin', NULL, '500mg', 'tablet', 60, 'Take one tablet twice a day with meals for type 2 diabetes management', 0, 'no'
    6, 'Lisinopril', NULL, '10mg', 'tablet', 30, 'Take one tablet once daily for high blood pressure management', 0, 'no'
    7, 'Omeprazole', NULL, '20mg', 'capsule', 28, 'Take one capsule once daily before breakfast for acid reflux management', 0, 'no'
    8, 'Atorvastatin', NULL, '20mg', 'tablet',  30, 'Take one tablet once daily for cholesterol management', 0, 'no'
    9, 'Warfarin', NULL, '5mg', 'tablet', 28, 'Take one tablet once daily for blood clot prevention', 0, 'yes'
    10, 'Prednisolone', NULL, '5mg', 'tablet', 21, 'Take one tablet once daily for inflammation management', 0, 'no'
    11, 'Citalopram', NULL, '20mg', 'tablet',   30, 'Take one tablet once daily for depression management', 0, 'no'
    12, 'Levothyroxine', NULL, '50mcg', 'tablet', 30, 'Take one tablet once daily for hypothyroidism management', 0, 'no'
    13, 'Furosemide', NULL, '40mg', 'tablet', 30, 'Take one tablet once daily for fluid retention management', 0, 'no'
    14, 'Clopidogrel', NULL, '75mg', 'tablet', 30, 'Take one tablet once daily for blood clot prevention', 0, 'no'
    15, 'Amlodipine', NULL, '5mg', 'tablet', 30, 'Take one tablet once daily for high blood pressure management', 0, 'no'
    16, 'Doxycycline', NULL, '100mg', 'capsule', 28, 'Take one capsule twice daily for 7 days for bacterial infection treatment', 0, 'no'
    17, 'Azithromycin', NULL, '250mg', 'tablet', 6, 'Take one tablet once daily for 3 days for bacterial infection treatment', 0, 'no'
    18, 'Cefalexin', NULL, '500mg', 'capsule', 28, 'Take one capsule every 6 hours for 7 days for bacterial infection treatment', 0, 'no'
    19, 'Clarithromycin', NULL, '500mg', 'tablet', 14, 'Take one tablet every 12 hours for 7 days for bacterial infection treatment', 0, 'no'
    20, 'Fluoxetine', NULL, '20mg', 'capsule', 30, 'Take one capsule once daily for depression management', 0, 'no'
    );
    INSERT INTO
    INSERT INTO Dispensing_information (Prescription_id, date_prescribed, date_dispensed, date_collected, branch, dispensing_pharmacist, charge_status, number_of_repeats_remaining, prescriber_id, patient_id, medication_name, number_of_repeats_authorised) VALUES 
    (
        1, '2023-01-01', '2023-01-02', '2023-01-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Amoxicillin', 0
        2, '2023-02-01', '2023-02-02', '2023-02-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Azithromycin', 0
        3, '2023-03-01', '2023-03-02', '2023-03-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Cefalexin', 0
        4, '2023-04-01', '2023-04-02', '2023-04-03', 'West End Branch', 'dispensed', 'paid', 0, 1, 1, 'Clarithromycin', 0
        5, '2023-05-01', '2023-05-02', '2023-05-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Doxycycline', 0
        6, '2023-06-01', '2023-06-02', '2023-06-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Fluoxetine', 0
        7, '2023-07-01', '2023-07-02', '2023-07-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Ibuprofen', 0
        8, '2023-08-01', '2023-08-02', '2023-08-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Levothyroxine', 0
        9, '2023-09-01', '2023-09-02    ', '2023-09-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Lisinopril', 0
        10, '2023-10-01', '2023-10-02', '2023-10-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Metformin', 0
        11, '2023-11-01', '2023-11-02', '2023-11-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Omeprazole', 0
        12, '2023-12-01', '2023-12-02', '2023-12-03', 'West End Branch', 'dispensed', 'paid', 0, 1, 1, 'Paracetamol', 0
        13, '2024-01-01', '2024-01-02', '2024-01-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Prednisolone', 0
        14, '2024-02-01', '2024-02-02', '2024-02-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Salbutamol Inhaler', 0
        15, '2024-03-01', '2024-03-02', '2024-03-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Warfarin', 0
        16, '2024-04-01', '2024-04-02', '2024-04-03', 'West End Branch', 'dispensed', 'paid', 0, 1, 1, 'Amlodipine', 0
        17, '2024-05-01', '2024-05-02', '2024-05-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Clopidogrel', 0
        18, '2024-06-01', '2024-06-02', '2024-06-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Furosemide', 0
        19, '2024-07-01', '2024-07-02', '2024-07-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Citalopram', 0
        20, '2024-08-01', '2024-08-02', '2024-08-03', 'West End Branch', 'dispensed', 'paid', 0, 1, 1, 'Atorvastatin', 0
        21, '2024-09-01', '2024-09-02', '2024-09-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Doxycycline', 0
        22, '2024-10-01', '2024-10-02', '2024-10-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Azithromycin', 0
        23, '2024-11-01', '2024-11-02', '2024-11-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Cefalexin', 0
        24, '2024-12-01', '2024-12-02', '2024-12-03', 'West End Branch', 'dispensed', 'paid', 0, 1, 1, 'Clarithromycin', 0
        25, '2025-01-01', '2025-01-02', '2025-01-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Doxycycline', 0
        26, '2025-02-01', '2025-02-02', '2025-02-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Fluoxetine', 0
        27, '2025-03-01', '2025-03-02', '2025-03-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Ibuprofen', 0
        28, '2025-04-01', '2025-04-02', '2025-04-03', 'Market Branch', 'dispensed', 'paid', 0, 1, 1, 'Levothyroxine', 0
        29, '2025-05-01', '2025-05-02', '2025-05-03', 'High Street Branch', 'dispensed', 'paid', 0, 1, 1, 'Lisinopril', 0
        30, '2025-06-01', '2025-06-02', '2025-06-03', 'Main Branch', 'dispensed', 'paid', 0, 1, 1, 'Metformin', 0
    );
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

INSERT INTO Dispensing_information
(
    Prescription_id, date_prescribed, date_dispensed, date_collected, branch, dispensing_pharmacist, charge_status, number_of_repeats_remaining, prescriber_id, patient_id, medication_id, number_of_repeats_authorised
)
VALUES
(
    1, '2023-01-01', '2023-01-02', '2023-01-03', 'Main Branch', 'pending', 'paid', 0, 1, 1, 1, 0  
);
INSERT INTO PRESCRIPTION_STATUS
(
    Prescription_id, status
);
VALUES
(
    1, 'dispensed'
);
SELECT 
(
    d.Prescription_id, d.date_prescribed, d.date_dispensed, d.date_collected, d.branch, d.dispensing_pharmacist, d.charge_status, d.number_of_repeats_remaining, d.prescriber_id, d.patient_id, d.medication_id, d.number_of_repeats_authorised

) FROM Dispensing_information
SELECT COUNT(d.Prescription_id) AS total_prescriptions_dispensed,
FROM Dispensing_information d
JOIN Prescription_status p ON d.patient_id = p.Patient_id
WHERE p.prescription_charge_exemption_category = 'aged 60 or over' AND d.dispensing_pharmacist = 'dispensed';
SELECT
(
    m.Medication_name
)FROM Medication_details m
Where m.Medication_name LIKE 'M%'
SELECT
(
    COUNT(d.Prescription_id,) AS total_prescriptions_dispensed,
    d.dispensing_pharmacist,
    d.branch,
) FROM dispensing_information d
WHERE d.date_dispensed BETWEEN '2023-01-01' AND '2023-06-01' AND dispensing_pharmacist = 'dispensed'
GROUP BY d.branch, dispensing_pharmacist
ORDER BY d.branch ASC, dispensing_pharmacist DESC;
SELECT
(
    d.Prescription_id, d.date_prescribed, d.date_dispensed, d.date_collected, d.branch, d.dispensing_pharmacist, d.charge_status, d.number_of_repeats_remaining, d.prescriber_id, d.patient_id, d.medication_id, d.number_of_repeats_authorised,
    p.Patient_id, p.first_name, p.last_name, p.date_of_birth,
    m.medicaton_id, m.medication_name, m.brand_name, m.strength, m.form, m.quantity, m.directions_for_use, m.medication_controlled,
    pr.prescriber_id, pr.prescriber_name, pr.prescriber_type, pr.practice_name, pr.practice_address, pr.practice_code, pr.professional_registration_number
) FROM Dispensing_information d
JOIN Patient_information p ON d.patient_id = p.Patient_id
JOIN Medication_details m ON d.medication_id = m.medication_id
JOIN Prescriber_information pr ON d.prescriber_id = pr.Prescriber_id
WHERE d.prescription_id = 1;
