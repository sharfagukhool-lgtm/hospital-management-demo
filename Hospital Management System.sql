CREATE DATABASE HospitalManagementDB
GO

USE HospitalManagementDB


-- Creating table users

CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- patients
CREATE TABLE Patients (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT UNIQUE NOT NULL,
    DateOfBirth DATE,
    Gender NVARCHAR(10),
    BloodType NVARCHAR(5),
    Allergies NVARCHAR(255),
    EmergencyContact NVARCHAR(100),
    InsuranceProvider NVARCHAR(100),
    Address NVARCHAR(255),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

-- appointment table
CREATE TABLE Appointments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    Date DATETIME NOT NULL,
    Reason NVARCHAR(255),
    Status NVARCHAR(20) DEFAULT 'SCHEDULED',
    FOREIGN KEY (PatientId) REFERENCES Users(Id),
    FOREIGN KEY (DoctorId) REFERENCES Users(Id)
);

-- Medical records table

CREATE TABLE MedicalRecords (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    Diagnosis NVARCHAR(255),
    Treatment NVARCHAR(255),
    Notes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientId) REFERENCES Users(Id),
    FOREIGN KEY (DoctorId) REFERENCES Users(Id)
);


-- Billing table
CREATE TABLE Billing (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Paid BIT DEFAULT 0,
    IssuedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientId) REFERENCES Users(Id)
);

-- Lab tests
CREATE TABLE LabTests (
    Id INT PRIMARY KEY IDENTITY(1,1),
    PatientId INT NOT NULL,
    TestName NVARCHAR(100),
    Result NVARCHAR(255),
    Date DATETIME,
    FOREIGN KEY (PatientId) REFERENCES Users(Id)
);

--------------------------------------------------------------------------
/* Inserting sample data */

-- Users data
INSERT INTO Users (Name, Email, PasswordHash, Role)
VALUES 
('Dr. Alice Smith', 'alice@hospital.com', 'hashed_pw_1', 'DOCTOR'),
('John Doe', 'john@patient.com', 'hashed_pw_2', 'PATIENT'),
('Nurse Betty', 'betty@hospital.com', 'hashed_pw_3', 'NURSE'),
('Admin Joe', 'joe@hospital.com', 'hashed_pw_4', 'ADMIN');

-- Patient
-- Assuming John Doe is a patient with UserId = 2
INSERT INTO Patients (UserId, DateOfBirth, Gender, BloodType, Allergies, EmergencyContact, InsuranceProvider, Address)
VALUES (2, '1990-05-12', 'Male', 'O+', 'Penicillin', 'Jane Doe - 555-1234', 'HealthPlus', '123 Main St');

-- appointments
INSERT INTO Appointments (PatientId, DoctorId, Date, Reason)
VALUES 
(2, 1, '2025-11-17 10:00', 'Routine checkup'),
(2, 1, '2025-11-24 14:00', 'Follow-up visit');

-- medical records
INSERT INTO MedicalRecords (PatientId, DoctorId, Diagnosis, Treatment, Notes)
VALUES 
(2, 1, 'Hypertension', 'Lifestyle changes and medication', 'Patient advised to reduce salt intake');

-- Billing
INSERT INTO Billing (PatientId, Amount, Paid)
VALUES 
(2, 150.00, 0),
(2, 75.00, 1);

-- labs
INSERT INTO LabTests (PatientId, TestName, Result, Date)
VALUES 
(2, 'Blood Pressure', '140/90 mmHg', '2025-11-17'),
(2, 'Cholesterol', 'High LDL', '2025-11-17');

-- SELECT statement to view data. 

SELECT * FROM [dbo].[Users]
SELECT * FROM [dbo].[Appointments]
SELECT * FROM [dbo].[Billing]
SELECT * FROM [dbo].[LabTests]
SELECT * FROM [dbo].[MedicalRecords]
SELECT * FROM [dbo].[MedicalRecords]

SELECT * FROM [dbo].[Patients]