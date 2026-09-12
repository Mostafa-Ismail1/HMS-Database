/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 10_SeedData.sql
Description: Sample seed data population across all hospital entities. Includes foreign 
             key dependency ordering, IDENTITY_INSERT management, and temporal table 
             versioning handling.
========================================================================================
*/

USE [HMS_DB]
GO

-- Temporarily disable system-versioning on Patients to allow historical seed insertion
IF OBJECTPROPERTY(OBJECT_ID('clinical.Patients'), 'TableTemporalType') = 2
BEGIN
    ALTER TABLE [clinical].[Patients] SET (SYSTEM_VERSIONING = OFF);
END
GO

-- =====================================================================================
-- Seed Data Inserts
-- =====================================================================================
[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [billing].[InsuranceProviders] ON 

INSERT [billing].[InsuranceProviders] ([ProviderID], [ProviderName], [ContactPhone]) VALUES (1, N'MedNet Egypt', N'19999')
INSERT [billing].[InsuranceProviders] ([ProviderID], [ProviderName], [ContactPhone]) VALUES (2, N'AXA Insurance', N'19555')
INSERT [billing].[InsuranceProviders] ([ProviderID], [ProviderName], [ContactPhone]) VALUES (3, N'AllianceCare', N'19222')
SET IDENTITY_INSERT [billing].[InsuranceProviders] OFF
GO
SET IDENTITY_INSERT [billing].[InvoiceItems] ON 

INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (1, 1, CAST(N'2025-03-15' AS Date), N'ICU Room x14 days', CAST(49000.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (2, 1, CAST(N'2025-03-15' AS Date), N'Lipid Profile Test', CAST(150.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (3, 2, CAST(N'2025-12-06' AS Date), N'Operation Room x5 days', CAST(25000.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (4, 3, CAST(N'2025-09-07' AS Date), N'General Room x2 days', CAST(2400.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (5, 4, CAST(N'2025-11-16' AS Date), N'Private Room x1 day', CAST(2200.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (6, 5, CAST(N'2025-11-01' AS Date), N'Consultation Fee - Cardiology', CAST(350.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (7, 6, CAST(N'2026-08-30' AS Date), N'MRI - Brain (Pending Order)', CAST(2500.00 AS Decimal(10, 2)))
INSERT [billing].[InvoiceItems] ([InvoiceItemID], [InvoiceID], [IssueDate], [Description], [Amount]) VALUES (8, 6, CAST(N'2026-08-30' AS Date), N'Private Room Deposit', CAST(2000.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [billing].[InvoiceItems] OFF
GO
SET IDENTITY_INSERT [billing].[Invoices] ON 

INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (1, 1, 9, CAST(49150.00 AS Decimal(10, 2)), CAST(N'2025-03-15' AS Date), N'Paid')
INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (2, 3, 10, CAST(25000.00 AS Decimal(10, 2)), CAST(N'2025-12-06' AS Date), N'Unpaid')
INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (3, 5, 11, CAST(2400.00 AS Decimal(10, 2)), CAST(N'2025-09-07' AS Date), N'Paid')
INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (4, 7, 12, CAST(2200.00 AS Decimal(10, 2)), CAST(N'2025-11-16' AS Date), N'Unpaid')
INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (5, 3, NULL, CAST(350.00 AS Decimal(10, 2)), CAST(N'2025-11-01' AS Date), N'Paid')
INSERT [billing].[Invoices] ([InvoiceID], [PatientID], [AdmissionID], [TotalAmount], [IssueDate], [Status]) VALUES (6, 13, 13, CAST(4500.00 AS Decimal(10, 2)), CAST(N'2026-08-30' AS Date), N'Unpaid')
SET IDENTITY_INSERT [billing].[Invoices] OFF
GO
INSERT [billing].[PatientInsurance] ([PatientID], [ProviderID], [PolicyNumber], [ExpiryDate]) VALUES (1, 1, N'POL-0001', CAST(N'2027-01-01' AS Date))
INSERT [billing].[PatientInsurance] ([PatientID], [ProviderID], [PolicyNumber], [ExpiryDate]) VALUES (2, 2, N'POL-0002', CAST(N'2026-06-01' AS Date))
INSERT [billing].[PatientInsurance] ([PatientID], [ProviderID], [PolicyNumber], [ExpiryDate]) VALUES (4, 1, N'POL-0003', CAST(N'2026-12-31' AS Date))
INSERT [billing].[PatientInsurance] ([PatientID], [ProviderID], [PolicyNumber], [ExpiryDate]) VALUES (8, 3, N'POL-0004', CAST(N'2027-03-15' AS Date))
INSERT [billing].[PatientInsurance] ([PatientID], [ProviderID], [PolicyNumber], [ExpiryDate]) VALUES (13, 2, N'POL-0005', CAST(N'2026-12-31' AS Date))
GO
SET IDENTITY_INSERT [clinical].[Admissions] ON 

INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (9, 1, 1, 1, CAST(N'2025-03-01T10:00:00.0000000' AS DateTime2), CAST(N'2025-03-15T12:00:00.0000000' AS DateTime2))
INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (10, 3, 5, 2, CAST(N'2025-12-01T09:00:00.0000000' AS DateTime2), CAST(N'2025-12-06T10:00:00.0000000' AS DateTime2))
INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (11, 5, 2, 4, CAST(N'2025-09-05T09:00:00.0000000' AS DateTime2), CAST(N'2025-09-07T16:00:00.0000000' AS DateTime2))
INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (12, 7, 6, 2, CAST(N'2025-11-15T08:00:00.0000000' AS DateTime2), CAST(N'2025-11-16T11:00:00.0000000' AS DateTime2))
INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (13, 13, 3, 3, CAST(N'2026-08-30T11:30:00.0000000' AS DateTime2), NULL)
INSERT [clinical].[Admissions] ([AdmissionID], [PatientID], [RoomID], [AdmittingDoctorID], [AdmissionDate], [DischargeDate]) VALUES (17, 4, 7, 1, CAST(N'2026-09-07T22:50:33.1414693' AS DateTime2), NULL)
SET IDENTITY_INSERT [clinical].[Admissions] OFF
GO
SET IDENTITY_INSERT [clinical].[Appointments] ON 

INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (1, 1, 1, CAST(N'2025-09-01T10:00:00.0000000' AS DateTime2), N'Completed', N'Routine Checkup')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (2, 2, 2, CAST(N'2025-09-08T11:00:00.0000000' AS DateTime2), N'Completed', N'Follow up')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (3, 3, 2, CAST(N'2025-11-01T09:00:00.0000000' AS DateTime2), N'Completed', N'Routine Checkup')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (4, 4, 5, CAST(N'2025-10-10T13:00:00.0000000' AS DateTime2), N'NoShow', N'Follow up')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (5, 5, 4, CAST(N'2025-09-05T15:00:00.0000000' AS DateTime2), N'Scheduled', N'Emergency consultation')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (6, 6, 3, CAST(N'2025-10-01T09:30:00.0000000' AS DateTime2), N'Scheduled', N'Routine Checkup')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (7, 7, 2, CAST(N'2025-11-15T10:00:00.0000000' AS DateTime2), N'Scheduled', N'Follow up')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (8, 8, 5, CAST(N'2025-12-20T12:00:00.0000000' AS DateTime2), N'Scheduled', N'Emergency consultation')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (9, 14, 5, CAST(N'2026-09-01T12:00:00.0000000' AS DateTime2), N'Scheduled', N'Fever and Cough')
INSERT [clinical].[Appointments] ([AppointmentID], [PatientID], [DoctorID], [AppointmentDate], [Status], [Reason]) VALUES (10, 13, 3, CAST(N'2026-08-30T10:00:00.0000000' AS DateTime2), N'Completed', N'Severe Migraine')
SET IDENTITY_INSERT [clinical].[Appointments] OFF
GO
SET IDENTITY_INSERT [clinical].[LabOrders] ON 

INSERT [clinical].[LabOrders] ([LabOrderID], [PatientID], [DoctorID], [LabTestID], [OrderDate], [ResultDate], [ResultValue], [Status]) VALUES (1, 1, 1, 1, CAST(N'2025-09-01' AS Date), CAST(N'2025-09-02' AS Date), N'WBC: 6.5, RBC: 4.8 (Normal Result)', N'Completed')
INSERT [clinical].[LabOrders] ([LabOrderID], [PatientID], [DoctorID], [LabTestID], [OrderDate], [ResultDate], [ResultValue], [Status]) VALUES (2, 2, 2, 2, CAST(N'2025-09-08' AS Date), CAST(N'2025-09-09' AS Date), N'Cholesterol: 180 mg/dL', N'Completed')
INSERT [clinical].[LabOrders] ([LabOrderID], [PatientID], [DoctorID], [LabTestID], [OrderDate], [ResultDate], [ResultValue], [Status]) VALUES (3, 13, 3, 4, CAST(N'2026-08-30' AS Date), NULL, NULL, N'Pending')
SET IDENTITY_INSERT [clinical].[LabOrders] OFF
GO
SET IDENTITY_INSERT [clinical].[LabTests] ON 

INSERT [clinical].[LabTests] ([LabTestID], [TestName], [Cost]) VALUES (1, N'Complete Blood Count (CBC)', CAST(150.00 AS Decimal(10, 2)))
INSERT [clinical].[LabTests] ([LabTestID], [TestName], [Cost]) VALUES (2, N'Lipid Profile', CAST(250.00 AS Decimal(10, 2)))
INSERT [clinical].[LabTests] ([LabTestID], [TestName], [Cost]) VALUES (3, N'Blood Glucose', CAST(80.00 AS Decimal(10, 2)))
INSERT [clinical].[LabTests] ([LabTestID], [TestName], [Cost]) VALUES (4, N'MRI - Brain', CAST(2500.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [clinical].[LabTests] OFF
GO
SET IDENTITY_INSERT [clinical].[Medications] ON 

INSERT [clinical].[Medications] ([MedicationID], [Name], [Manufacturer], [UnitPrice]) VALUES (1, N'Paracetamol 500mg', N'EIPICO', CAST(15.00 AS Decimal(10, 2)))
INSERT [clinical].[Medications] ([MedicationID], [Name], [Manufacturer], [UnitPrice]) VALUES (2, N'Amoxicillin 250mg', N'GSK', CAST(45.00 AS Decimal(10, 2)))
INSERT [clinical].[Medications] ([MedicationID], [Name], [Manufacturer], [UnitPrice]) VALUES (3, N'Atorvastatin 20mg', N'Pfizer', CAST(90.00 AS Decimal(10, 2)))
INSERT [clinical].[Medications] ([MedicationID], [Name], [Manufacturer], [UnitPrice]) VALUES (4, N'Ibuprofen 400mg', N'Sanofi', CAST(20.00 AS Decimal(10, 2)))
INSERT [clinical].[Medications] ([MedicationID], [Name], [Manufacturer], [UnitPrice]) VALUES (5, N'Losartan 50mg', N'Novartis', CAST(60.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [clinical].[Medications] OFF
GO
SET IDENTITY_INSERT [clinical].[Patients] ON 

INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (1, N'Alaa', N'Mohamed', CAST(N'2000-01-01' AS Date), N'01000000001', N'M', NULL, NULL, N'O+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (2, N'Mona', N'Eid', CAST(N'1990-03-01' AS Date), N'01000000002', N'F', NULL, NULL, N'A+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (3, N'Mohamed', N'Ibrahim', CAST(N'1985-04-12' AS Date), N'01000000003', N'M', NULL, NULL, N'B-', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (4, N'Salma', N'Reda', CAST(N'1990-09-23' AS Date), N'01000000004', N'F', NULL, NULL, N'AB+', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (5, N'Youssef', N'Amin', CAST(N'1978-01-05' AS Date), N'01000000005', N'M', NULL, NULL, N'O+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (6, N'Nadia', N'Farouk', CAST(N'2001-11-30' AS Date), N'01000000006', N'F', NULL, NULL, N'A+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (7, N'Khaled', N'Sabry', CAST(N'1965-06-18' AS Date), N'01000000007', N'M', N'khaled.sabry@gmail.com', NULL, NULL, CAST(N'2026-09-06T23:12:47.6128032' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (8, N'Rana', N'Gamal', CAST(N'1995-03-09' AS Date), N'01000000008', N'F', NULL, NULL, N'AB+', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (9, N'Hossam', N'Zaki', CAST(N'1988-12-25' AS Date), N'01000000009', N'M', NULL, NULL, N'O+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (10, N'Marwa', N'Adel', CAST(N'1999-07-14' AS Date), N'01000000010', N'F', NULL, NULL, N'A+', CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (11, N'Amr', N'Shawky', CAST(N'1972-02-28' AS Date), N'01000000011', N'M', NULL, NULL, N'B-', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (12, N'Farida', N'Mahmoud', CAST(N'2010-05-19' AS Date), N'01000000012', N'F', NULL, NULL, N'AB+', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (13, N'Omar', N'Hassan', CAST(N'1992-11-05' AS Date), N'01000000013', N'M', N'omar.h@email.com', N'Cairo, Nasr City', N'O-', CAST(N'2026-08-26T17:16:03.2884605' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (14, N'Laila', N'Samir', CAST(N'2018-05-10' AS Date), N'01000000014', N'F', NULL, N'Giza, Dokki', N'B+', CAST(N'2026-08-26T17:16:03.2884605' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (15, N'Mostafa', N'Ali', CAST(N'2003-01-01' AS Date), N'01000000015', N'M', N'msf@gmail.com', N'Cairo', N'O+', CAST(N'2026-09-06T17:03:28.3707971' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (16, N'Eid', N'Ismail', CAST(N'2002-01-01' AS Date), N'+123456787', N'M', N'EIDEIDgmail.com', N'Cairo, Egypt', N'O+', CAST(N'2026-09-06T21:16:40.8166949' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (18, N'Saad', N'Ahmed', CAST(N'2000-09-06' AS Date), N'+6787433', N'M', N'SAADgmail.com', N'Cairo', N'O+', CAST(N'2026-09-06T21:24:42.4699310' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (19, N'Hosa', N'Aadel', CAST(N'2010-09-06' AS Date), N'+600000001', N'M', N'Hossa@gmail.com', N'Cairo', N'O+', CAST(N'2026-09-06T21:29:40.3374192' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
INSERT [clinical].[Patients] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (20, N'samy', N'Ahmed', CAST(N'2026-05-07' AS Date), N'01000000099', N'M', N'Samy@gmail.com', N'Cairo', N'O+', CAST(N'2026-09-07T18:22:18.8760480' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2))
SET IDENTITY_INSERT [clinical].[Patients] OFF
GO
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (2, N'Mona', N'Eid', CAST(N'1990-03-01' AS Date), N'01000002', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (4, N'Salma', N'Reda', CAST(N'1990-09-23' AS Date), N'01000004', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (6, N'Nadia', N'Farouk', CAST(N'2001-11-30' AS Date), N'01000006', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (8, N'Rana', N'Gamal', CAST(N'1995-03-09' AS Date), N'01000008', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (10, N'Marwa', N'Adel', CAST(N'1999-07-14' AS Date), N'01000010', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (12, N'Farida', N'Mahmoud', CAST(N'2010-05-19' AS Date), N'01000012', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (1, N'Alaa', N'Mohamed', CAST(N'2000-01-01' AS Date), N'01000001', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (3, N'Mohamed', N'Ibrahim', CAST(N'1985-04-12' AS Date), N'01000003', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (5, N'Youssef', N'Amin', CAST(N'1978-01-05' AS Date), N'01000005', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (7, N'Khaled', N'Sabry', CAST(N'1965-06-18' AS Date), N'01000007', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (9, N'Hossam', N'Zaki', CAST(N'1988-12-25' AS Date), N'01000009', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (11, N'Amr', N'Shawky', CAST(N'1972-02-28' AS Date), N'01000011', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T15:03:12.0353003' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (2, N'Mona', N'Eid', CAST(N'1990-03-01' AS Date), N'01000002', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (4, N'Salma', N'Reda', CAST(N'1990-09-23' AS Date), N'01000004', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (6, N'Nadia', N'Farouk', CAST(N'2001-11-30' AS Date), N'01000006', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (8, N'Rana', N'Gamal', CAST(N'1995-03-09' AS Date), N'01000008', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (10, N'Marwa', N'Adel', CAST(N'1999-07-14' AS Date), N'01000010', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (12, N'Farida', N'Mahmoud', CAST(N'2010-05-19' AS Date), N'01000012', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3244939' AS DateTime2), CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (1, N'Alaa', N'Mohamed', CAST(N'2000-01-01' AS Date), N'01000000001', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (5, N'Youssef', N'Amin', CAST(N'1978-01-05' AS Date), N'01000000005', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (9, N'Hossam', N'Zaki', CAST(N'1988-12-25' AS Date), N'01000000009', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (2, N'Mona', N'Eid', CAST(N'1990-03-01' AS Date), N'01000000002', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (6, N'Nadia', N'Farouk', CAST(N'2001-11-30' AS Date), N'01000000006', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (10, N'Marwa', N'Adel', CAST(N'1999-07-14' AS Date), N'01000000010', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3366397' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (3, N'Mohamed', N'Ibrahim', CAST(N'1985-04-12' AS Date), N'01000000003', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (7, N'Khaled', N'Sabry', CAST(N'1965-06-18' AS Date), N'01000000007', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (11, N'Amr', N'Shawky', CAST(N'1972-02-28' AS Date), N'01000000011', N'M', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (4, N'Salma', N'Reda', CAST(N'1990-09-23' AS Date), N'01000000004', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (8, N'Rana', N'Gamal', CAST(N'1995-03-09' AS Date), N'01000000008', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (12, N'Farida', N'Mahmoud', CAST(N'2010-05-19' AS Date), N'01000000012', N'F', NULL, NULL, NULL, CAST(N'2026-08-26T16:10:16.3356849' AS DateTime2), CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (15, N'Mostafa', N'Ali', CAST(N'2003-01-01' AS Date), N'+201013298984', N'M', N'msf@gmail.com', N'Cairo', N'O+', CAST(N'2026-09-06T16:59:02.5303661' AS DateTime2), CAST(N'2026-09-06T17:03:28.3707971' AS DateTime2))
INSERT [clinical].[Patients_History] ([PatientID], [FirstName], [LastName], [DOB], [Phone], [Gender], [Email], [Address], [BloodType], [ValidFrom], [ValidTo]) VALUES (7, N'Khaled', N'Sabry', CAST(N'1965-06-18' AS Date), N'01000000007', N'M', NULL, NULL, N'B-', CAST(N'2026-08-26T16:10:16.3375504' AS DateTime2), CAST(N'2026-09-06T23:12:47.6128032' AS DateTime2))
GO
INSERT [clinical].[PrescriptionDetails] ([PrescriptionID], [MedicationID], [Dosage], [Duration]) VALUES (1, 3, N'1 tablet nightly', N'30 days')
INSERT [clinical].[PrescriptionDetails] ([PrescriptionID], [MedicationID], [Dosage], [Duration]) VALUES (1, 5, N'1 tablet daily', N'30 days')
INSERT [clinical].[PrescriptionDetails] ([PrescriptionID], [MedicationID], [Dosage], [Duration]) VALUES (2, 1, N'1 tablet every 6 hours', N'5 days')
INSERT [clinical].[PrescriptionDetails] ([PrescriptionID], [MedicationID], [Dosage], [Duration]) VALUES (3, 4, N'1 tablet every 8 hours', N'7 days')
INSERT [clinical].[PrescriptionDetails] ([PrescriptionID], [MedicationID], [Dosage], [Duration]) VALUES (4, 1, N'1/2 tablet every 8 hours', N'3 days')
GO
SET IDENTITY_INSERT [clinical].[Prescriptions] ON 

INSERT [clinical].[Prescriptions] ([PrescriptionID], [AppointmentID], [DoctorID], [PatientID], [DatePrescribed]) VALUES (1, 1, 1, 1, CAST(N'2025-09-01' AS Date))
INSERT [clinical].[Prescriptions] ([PrescriptionID], [AppointmentID], [DoctorID], [PatientID], [DatePrescribed]) VALUES (2, 2, 2, 2, CAST(N'2025-09-08' AS Date))
INSERT [clinical].[Prescriptions] ([PrescriptionID], [AppointmentID], [DoctorID], [PatientID], [DatePrescribed]) VALUES (3, 4, 5, 4, CAST(N'2025-10-10' AS Date))
INSERT [clinical].[Prescriptions] ([PrescriptionID], [AppointmentID], [DoctorID], [PatientID], [DatePrescribed]) VALUES (4, 9, 5, 14, CAST(N'2026-09-01' AS Date))
SET IDENTITY_INSERT [clinical].[Prescriptions] OFF
GO
SET IDENTITY_INSERT [hr].[Departments] ON 

INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (1, N'Surgery', N'Building A - Floor 2')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (2, N'Cardiology', N'Building A - Floor 3')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (3, N'Neurology', N'Building B - Floor 1')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (4, N'Oncology', N'Building B - Floor 2')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (5, N'Pediatrics', N'Building C - Floor 1')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (6, N'Administration & Reception', N'Main Building - Ground Floor')
INSERT [hr].[Departments] ([DepartmentID], [DepartmentName], [Location]) VALUES (7, N'Finance & Accounting', N'Main Building - Floor 1')
SET IDENTITY_INSERT [hr].[Departments] OFF
GO
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (1, N'Surgeon', N'LIC-001')
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (2, N'Cardiology', N'LIC-002')
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (3, N'Neurologist', N'LIC-003')
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (4, N'Oncologist', N'LIC-004')
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (5, N'Pediatrician', N'LIC-005')
INSERT [hr].[Doctors] ([DoctorID], [Specialization], [LicenseNumber]) VALUES (7, N'Cardiology', N'LIC-007')
GO
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (1, 1, N'Mon', CAST(N'09:00:00' AS Time), CAST(N'14:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (1, 1, N'Sat', CAST(N'09:00:00' AS Time), CAST(N'14:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (2, 2, N'Sat', CAST(N'11:00:00' AS Time), CAST(N'17:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (3, 3, N'Sun', CAST(N'09:00:00' AS Time), CAST(N'15:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (4, 4, N'Mon', CAST(N'08:00:00' AS Time), CAST(N'13:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (5, 5, N'Wed', CAST(N'09:00:00' AS Time), CAST(N'17:00:00' AS Time))
INSERT [hr].[DoctorSchedules] ([DoctorID], [DepartmentID], [DayOfWeek], [StartTime], [EndTime]) VALUES (7, 2, N'Sun', CAST(N'10:00:00' AS Time), CAST(N'16:00:00' AS Time))
GO

SET IDENTITY_INSERT [hr].[Rooms] ON 

INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (1, N'A-201', N'ICU', 1, CAST(3500.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (2, N'A-202', N'General', 1, CAST(1200.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (3, N'B-101', N'Private', 3, CAST(2000.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (4, N'B-205', N'General', 4, CAST(1000.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (5, N'C-301', N'Operation', 5, CAST(5000.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (6, N'C-302', N'Private', 5, CAST(2200.00 AS Decimal(10, 2)))
INSERT [hr].[Rooms] ([RoomID], [RoomNumber], [RoomType], [DepartmentID], [DailyRate]) VALUES (7, N'D-401', N'Private', 3, CAST(100.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [hr].[Rooms] OFF
GO

SET IDENTITY_INSERT [hr].[Staff] ON 

INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (1, N'Ahmed', N'Ali', N'ahmed.ali@hms.com', N'01000000001', CAST(N'2025-03-24' AS Date), 1, N'Doctor', CAST(20000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (2, N'Gamal', N'Khaled', N'gamal.khaled@hms.com', N'01000000002', CAST(N'2025-01-22' AS Date), 2, N'Doctor', CAST(22000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (3, N'Tamer', N'Omar', N'tamer.omar@hms.com', N'01000000003', CAST(N'2025-07-10' AS Date), 3, N'Doctor', CAST(21000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (4, N'Amar', N'Mohsen', N'amar.mohsen@hms.com', N'01000000004', CAST(N'2025-02-04' AS Date), 4, N'Doctor', CAST(23000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (5, N'Mostafa', N'Ali', N'mostafa.ali@hms.com', N'01000000005', CAST(N'2025-04-01' AS Date), 5, N'Doctor', CAST(19000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (7, N'Waled', N'Ahmed', N'waled.ahmed@hms.com', N'01000000007', CAST(N'2025-05-06' AS Date), 2, N'Doctor', CAST(22000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (8, N'Salma', N'Youssef', N'salma.youssef@hms.com', N'01000000008', CAST(N'2025-03-01' AS Date), 1, N'Nurse', CAST(9000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (10, N'Mahmoud', N'El-Sayed', N'mahmoud.director@hms.com', N'01011112222', CAST(N'2020-01-15' AS Date), 6, N'Hospital Director', CAST(45000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (11, N'Nour', N'Hassan', N'nour.hassan@hms.com', N'01022223333', CAST(N'2023-03-01' AS Date), 6, N'Receptionist', CAST(8500.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (12, N'Youssef', N'Kareem', N'youssef.kareem@hms.com', N'01033334444', CAST(N'2023-06-15' AS Date), 6, N'Receptionist', CAST(8000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (13, N'Mariam', N'Adel', N'mariam.adel@hms.com', N'01044445555', CAST(N'2024-01-10' AS Date), 6, N'Receptionist', CAST(8200.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (14, N'Fatma', N'Ali', N'fatma.ali@hms.com', N'01055556666', CAST(N'2024-02-01' AS Date), 2, N'Nurse', CAST(9500.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (15, N'Aya', N'Ibrahim', N'aya.ibrahim@hms.com', N'01066667777', CAST(N'2024-03-15' AS Date), 5, N'Nurse', CAST(9200.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (16, N'Mona', N'Hassan', N'mona.hassan@hms.com', N'01077778888', CAST(N'2024-05-01' AS Date), 3, N'Nurse', CAST(9000.00 AS Decimal(10, 2)))
INSERT [hr].[Staff] ([StaffID], [FirstName], [LastName], [Email], [Phone], [HireDate], [DepartmentID], [JobTitle], [Salary]) VALUES (17, N'Khaled', N'El-Sayed', N'khaled.accountant@hms.com', N'01088889999', CAST(N'2023-11-01' AS Date), 7, N'Accountant', CAST(14000.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [hr].[Staff] OFF
GO

INSERT [hr].[Nurses] ([NurseID], [ShiftType]) VALUES (8, N'Evening')
INSERT [hr].[Nurses] ([NurseID], [ShiftType]) VALUES (14, N'Morning')
INSERT [hr].[Nurses] ([NurseID], [ShiftType]) VALUES (15, N'Night')
INSERT [hr].[Nurses] ([NurseID], [ShiftType]) VALUES (16, N'Evening')
GO

-- Re-enable system-versioning on Patients table
IF OBJECTPROPERTY(OBJECT_ID('clinical.Patients'), 'TableTemporalType') = 0
BEGIN
    ALTER TABLE [clinical].[Patients] 
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [clinical].[Patients_History], DATA_CONSISTENCY_CHECK = ON));
END
GO
