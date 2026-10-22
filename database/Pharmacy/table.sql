CREATE DATABASE IF NOT EXISTS Pharmacy;
USE Pharmacy;
CREATE TABLE IF NOT EXISTS Patient_information
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
)
CREATE TABLE IF NOT EXISTS Prescriber_information
(
    Prescriber_id INT PRIMARY KEY NOT NULL UNIQUE,
    prescriber_name VARCHAR(100),
    prescriber_type enum('GP', 'nurse prescriber', 'pharmacist prescriber', 'hospital consultant', 'dentist') NOT NULL,
    practice_name VARCHAR(100),
    practice_address VARCHAR(100),
    practice_code INT,
    professional_registration_number VARCHAR(20) UNIQUE
)
CREATE TABLE IF NOT EXISTS Medication_details
(
    medication_name VARCHAR(100) NOT NULL PRIMARY KEY,
    brand_name VARCHAR(100), 
    strength VARCHAR(50),
    form enum('tablet', 'capsule', 'liquid') NOT NULL,
    quantity INT,
    directions_for_use VARCHAR(255),
    number_of_repeats_authorised INT,
    medication_controlled enum('yes', 'no') NOT NULL
)
CREATE TABLE IF NOT EXISTS Dispensing_information
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    date_prescribed DATE,
    date_dispensed DATE,
    date_collected DATE,
    branch VARCHAR(100),
    --dispensing_pharmacist VARCHAR(3) NOT NULL CHECK (dispensing_pharmacist IN ('pending', 'dispensed', 'collected', 'cancelled')),
    dispensing_pharmacist enum('pending', 'dispensed', 'collected', 'cancelled') NOT NULL,
    --charge_status VARCHAR(3) NOT NULL CHECK (charge_status IN ('paid','exempt')),
    charge_status enum('paid','exempt') NOT NULL,
)
CREATE TABLE IF NOT EXISTS Prescription_status
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*pending BOOLEAN,
    dispensed BOOLEAN,
    collected BOOLEAN,
    cancelled BOOLEAN,*/
)
insert into Prescription_status (Prescription_id) values (1, 'pending', 'dispensed', 'collected', 'cancelled');
CREATE TABLE IF NOT EXISTS Medication_form
(
    Medication_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*tablet BOOLEAN,
    capsule BOOLEAN,*/
)
insert into Medication_form (Medication_id) values (1, 'tablet', 'capsule', 'liquid');
CREATE TABLE IF NOT EXISTS Prescriber_type
(
    Prescriber_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*GP BOOLEAN,
    nurse_prescriber BOOLEAN,
    pharmacist_prescriber BOOLEAN,
    hospital_consultant BOOLEAN,
    dentist BOOLEAN,*/
)
INSERT INTO Prescriber_type (Prescriber_id) VALUES (1, 'GP', 'nurse prescriber', 'pharmacist prescriber', 'hospital consultant', 'dentist');
CREATE TABLE IF NOT EXISTS Prescription_charge_exemption_category
(
    Patient_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*under_16 BOOLEAN,
    aged_16_to_18_and_in_full_time_education BOOLEAN,
    aged_60_or_over BOOLEAN,
    maternity_exemption BOOLEAN,
    medical_exemption BOOLEAN,
    prepayment_certificate BOOLEAN,
    none_charge_paid BOOLEAN,*/
)
INSERT INTO Prescription_charge_exemption_category (Patient_id) values (1, 'under 16', 'aged 16 to 18 and in full time education', 'aged 60 or over', 'maternity exemption', 'medical exemption', 'prepayment certificate', 'none, charge paid');
CREATE TABLE IF NOT EXISTS Medication_controlled
(
    Medication_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*yes BOOLEAN,
    no BOOLEAN,*/
)
INSERT INTO Medication_controlled (Medication_id) VALUES (1, 'yes', 'no');
CREATE TABLE IF NOT EXISTS Staff_roles
(
    Prescription_id INT PRIMARY KEY NOT NULL UNIQUE,
    /*dispensing_pharmacist BOOLEAN,
    prescriber BOOLEAN,*/
)
INSERT INTO Staff_roles (Prescription_id) VALUES (1, 'pharmacist', 'dispensing_assistant', 'branch_manager', 'head office administrator');