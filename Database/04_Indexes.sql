/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 04_Indexes.sql
Description: Unique nonclustered constraints, performance search indexes, and filtered
             indexes for query optimization.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- Nonclustered & Filtered Performance Indexes
-- =====================================================================================
/****** Object:  Index [UQ__Insuranc__7D057CE57B49CCD0]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [billing].[InsuranceProviders] ADD UNIQUE NONCLUSTERED 
(
	[ProviderName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_Invoices_Patient]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_Invoices_Patient] ON [billing].[Invoices]
(
	[PatientID] ASC,
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [UQ_Doctor_Slot]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [clinical].[Appointments] ADD  CONSTRAINT [UQ_Doctor_Slot] UNIQUE NONCLUSTERED 
(
	[DoctorID] ASC,
	[AppointmentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_Appointments_Date]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_Date] ON [clinical].[Appointments]
(
	[AppointmentDate] ASC
)
INCLUDE([PatientID],[DoctorID],[Status]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_Appointments_Scheduled_Filtered]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_Scheduled_Filtered] ON [clinical].[Appointments]
(
	[AppointmentDate] ASC
)
WHERE ([Status]='Scheduled')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_LabOrders_Doctor]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_LabOrders_Doctor] ON [clinical].[LabOrders]
(
	[DoctorID] ASC,
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [UQ__LabTests__2AF07A7D2B799BB3]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [clinical].[LabTests] ADD UNIQUE NONCLUSTERED 
(
	[TestName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_Patients_Name]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_Patients_Name] ON [clinical].[Patients]
(
	[LastName] ASC,
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [UQ__Prescrip__8ECDFCA39E2C5272]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [clinical].[Prescriptions] ADD UNIQUE NONCLUSTERED 
(
	[AppointmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [UQ__Doctors__E88901669ECF2ACC]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [hr].[Doctors] ADD UNIQUE NONCLUSTERED 
(
	[LicenseNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [UQ__Rooms__AE10E07A21D8398C]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [hr].[Rooms] ADD UNIQUE NONCLUSTERED 
(
	[RoomNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO

/****** Object:  Index [UQ__Staff__A9D105342096F3E6]    Script Date: 9/8/2026 3:44:25 PM ******/
ALTER TABLE [hr].[Staff] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [billing].[Invoices] ADD  DEFAULT ((0)) FOR [TotalAmount]
GO
ALTER TABLE [billing].[Invoices] ADD  DEFAULT (CONVERT([date],getdate())) FOR [IssueDate]
GO
ALTER TABLE [billing].[Invoices] ADD  DEFAULT ('Unpaid') FOR [Status]
GO
ALTER TABLE [billing].[InvoiceStatusLog] ADD  DEFAULT (sysdatetime()) FOR [ChangedAt]
GO
ALTER TABLE [clinical].[Admissions] ADD  DEFAULT (sysdatetime()) FOR [AdmissionDate]
GO
ALTER TABLE [clinical].[Appointments] ADD  DEFAULT ('Scheduled') FOR [Status]
GO
ALTER TABLE [clinical].[LabOrders] ADD  DEFAULT (CONVERT([date],getdate())) FOR [OrderDate]
GO
ALTER TABLE [clinical].[LabOrders] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [clinical].[Patients] ADD  CONSTRAINT [DF_Patients_Gender]  DEFAULT ('M') FOR [Gender]
GO
ALTER TABLE [clinical].[Patients] ADD  DEFAULT (sysutcdatetime()) FOR [ValidFrom]
GO
ALTER TABLE [clinical].[Patients] ADD  DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) FOR [ValidTo]
GO
ALTER TABLE [clinical].[Prescriptions] ADD  DEFAULT (CONVERT([date],getdate())) FOR [DatePrescribed]
GO
ALTER TABLE [hr].[Staff] ADD  DEFAULT (getdate()) FOR [HireDate]
GO
ALTER TABLE [billing].[InvoiceItems]  WITH CHECK ADD  CONSTRAINT [FK_Items_Invoice] FOREIGN KEY([InvoiceID], [IssueDate])
REFERENCES [billing].[Invoices] ([InvoiceID], [IssueDate])
GO
ALTER TABLE [billing].[InvoiceItems] CHECK CONSTRAINT [FK_Items_Invoice]
GO
ALTER TABLE [billing].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Inv_Admission] FOREIGN KEY([AdmissionID])
REFERENCES [clinical].[Admissions] ([AdmissionID])
GO
ALTER TABLE [billing].[Invoices] CHECK CONSTRAINT [FK_Inv_Admission]
GO
ALTER TABLE [billing].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Inv_Patient] FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [billing].[Invoices] CHECK CONSTRAINT [FK_Inv_Patient]
GO
ALTER TABLE [billing].[PatientInsurance]  WITH CHECK ADD FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [billing].[PatientInsurance]  WITH CHECK ADD FOREIGN KEY([ProviderID])
REFERENCES [billing].[InsuranceProviders] ([ProviderID])
GO
ALTER TABLE [clinical].[Admissions]  WITH CHECK ADD  CONSTRAINT [FK_Adm_Doctor] FOREIGN KEY([AdmittingDoctorID])
REFERENCES [hr].[Doctors] ([DoctorID])
GO
ALTER TABLE [clinical].[Admissions] CHECK CONSTRAINT [FK_Adm_Doctor]
GO
ALTER TABLE [clinical].[Admissions]  WITH CHECK ADD  CONSTRAINT [FK_Admissions_Patient] FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [clinical].[Admissions] CHECK CONSTRAINT [FK_Admissions_Patient]
GO
ALTER TABLE [clinical].[Admissions]  WITH CHECK ADD  CONSTRAINT [FK_Admissions_Room] FOREIGN KEY([RoomID])
REFERENCES [hr].[Rooms] ([RoomID])
GO
ALTER TABLE [clinical].[Admissions] CHECK CONSTRAINT [FK_Admissions_Room]
GO
ALTER TABLE [clinical].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_App_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [hr].[Doctors] ([DoctorID])
GO
ALTER TABLE [clinical].[Appointments] CHECK CONSTRAINT [FK_App_Doctor]
GO
ALTER TABLE [clinical].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK_Appointments_Patient] FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [clinical].[Appointments] CHECK CONSTRAINT [FK_Appointments_Patient]
GO
ALTER TABLE [clinical].[LabOrders]  WITH CHECK ADD  CONSTRAINT [FK_Lab_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [hr].[Doctors] ([DoctorID])
GO
ALTER TABLE [clinical].[LabOrders] CHECK CONSTRAINT [FK_Lab_Doctor]
GO
ALTER TABLE [clinical].[LabOrders]  WITH CHECK ADD  CONSTRAINT [FK_Lab_Patient] FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [clinical].[LabOrders] CHECK CONSTRAINT [FK_Lab_Patient]
GO
ALTER TABLE [clinical].[LabOrders]  WITH CHECK ADD  CONSTRAINT [FK_Lab_Test] FOREIGN KEY([LabTestID])
REFERENCES [clinical].[LabTests] ([LabTestID])
GO
ALTER TABLE [clinical].[LabOrders] CHECK CONSTRAINT [FK_Lab_Test]
GO
ALTER TABLE [clinical].[PrescriptionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PD_Medication] FOREIGN KEY([MedicationID])
REFERENCES [clinical].[Medications] ([MedicationID])
GO
ALTER TABLE [clinical].[PrescriptionDetails] CHECK CONSTRAINT [FK_PD_Medication]
GO
ALTER TABLE [clinical].[PrescriptionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PD_Prescription] FOREIGN KEY([PrescriptionID])
REFERENCES [clinical].[Prescriptions] ([PrescriptionID])
ON DELETE CASCADE
GO
ALTER TABLE [clinical].[PrescriptionDetails] CHECK CONSTRAINT [FK_PD_Prescription]
GO
ALTER TABLE [clinical].[Prescriptions]  WITH CHECK ADD  CONSTRAINT [FK_Presc_Appointment] FOREIGN KEY([AppointmentID])
REFERENCES [clinical].[Appointments] ([AppointmentID])
GO
ALTER TABLE [clinical].[Prescriptions] CHECK CONSTRAINT [FK_Presc_Appointment]
GO
ALTER TABLE [clinical].[Prescriptions]  WITH CHECK ADD  CONSTRAINT [FK_Presc_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [hr].[Doctors] ([DoctorID])
GO
ALTER TABLE [clinical].[Prescriptions] CHECK CONSTRAINT [FK_Presc_Doctor]
GO
ALTER TABLE [clinical].[Prescriptions]  WITH CHECK ADD  CONSTRAINT [FK_Presc_Patient] FOREIGN KEY([PatientID])
REFERENCES [clinical].[Patients] ([PatientID])
GO
ALTER TABLE [clinical].[Prescriptions] CHECK CONSTRAINT [FK_Presc_Patient]
GO
ALTER TABLE [hr].[Doctors]  WITH CHECK ADD  CONSTRAINT [FK_Doctors_Staff] FOREIGN KEY([DoctorID])
REFERENCES [hr].[Staff] ([StaffID])
ON DELETE CASCADE
GO
ALTER TABLE [hr].[Doctors] CHECK CONSTRAINT [FK_Doctors_Staff]
GO
ALTER TABLE [hr].[DoctorSchedules]  WITH CHECK ADD FOREIGN KEY([DepartmentID])
REFERENCES [hr].[Departments] ([DepartmentID])
GO
ALTER TABLE [hr].[DoctorSchedules]  WITH CHECK ADD FOREIGN KEY([DoctorID])
REFERENCES [hr].[Doctors] ([DoctorID])
GO
ALTER TABLE [hr].[Nurses]  WITH CHECK ADD  CONSTRAINT [FK_Nurses_Staff] FOREIGN KEY([NurseID])
REFERENCES [hr].[Staff] ([StaffID])
ON DELETE CASCADE
GO
ALTER TABLE [hr].[Nurses] CHECK CONSTRAINT [FK_Nurses_Staff]
GO
ALTER TABLE [hr].[Rooms]  WITH CHECK ADD  CONSTRAINT [FK_Rooms_Department] FOREIGN KEY([DepartmentID])
REFERENCES [hr].[Departments] ([DepartmentID])
GO
ALTER TABLE [hr].[Rooms] CHECK CONSTRAINT [FK_Rooms_Department]
GO
ALTER TABLE [hr].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Department] FOREIGN KEY([DepartmentID])
REFERENCES [hr].[Departments] ([DepartmentID])
GO
ALTER TABLE [hr].[Staff] CHECK CONSTRAINT [FK_Staff_Department]
GO
ALTER TABLE [billing].[InvoiceItems]  WITH CHECK ADD CHECK  (([Amount]>=(0)))
GO
ALTER TABLE [billing].[Invoices]  WITH CHECK ADD CHECK  (([Status]='Cancelled' OR [Status]='Paid' OR [Status]='Unpaid'))
GO
ALTER TABLE [billing].[Invoices]  WITH CHECK ADD CHECK  (([TotalAmount]>=(0)))
GO
ALTER TABLE [clinical].[Admissions]  WITH CHECK ADD  CONSTRAINT [CK_Adm_Dates] CHECK  (([DischargeDate] IS NULL OR [DischargeDate]>=[AdmissionDate]))
GO
ALTER TABLE [clinical].[Admissions] CHECK CONSTRAINT [CK_Adm_Dates]
GO
ALTER TABLE [clinical].[Appointments]  WITH CHECK ADD  CONSTRAINT [CK_App_Status] CHECK  (([Status]='NoShow' OR [Status]='Cancelled' OR [Status]='Completed' OR [Status]='Scheduled'))
GO
ALTER TABLE [clinical].[Appointments] CHECK CONSTRAINT [CK_App_Status]
GO
ALTER TABLE [clinical].[LabOrders]  WITH CHECK ADD CHECK  (([Status]='Cancelled' OR [Status]='Completed' OR [Status]='Pending'))
GO
ALTER TABLE [clinical].[LabOrders]  WITH CHECK ADD  CONSTRAINT [CK_Lab_ResultDate] CHECK  (([ResultDate] IS NULL OR [ResultDate]>=[OrderDate]))
GO
ALTER TABLE [clinical].[LabOrders] CHECK CONSTRAINT [CK_Lab_ResultDate]
GO
ALTER TABLE [clinical].[LabTests]  WITH CHECK ADD CHECK  (([Cost]>=(0)))
GO
ALTER TABLE [clinical].[Medications]  WITH CHECK ADD CHECK  (([UnitPrice]>(0)))
GO
ALTER TABLE [clinical].[Patients]  WITH CHECK ADD  CONSTRAINT [CK_Patients_BloodType] CHECK  (([BloodType]='O-' OR [BloodType]='O+' OR [BloodType]='AB-' OR [BloodType]='AB+' OR [BloodType]='B-' OR [BloodType]='B+' OR [BloodType]='A-' OR [BloodType]='A+'))
GO
ALTER TABLE [clinical].[Patients] CHECK CONSTRAINT [CK_Patients_BloodType]
GO
ALTER TABLE [clinical].[Patients]  WITH CHECK ADD  CONSTRAINT [CK_Patients_Gender] CHECK  (([Gender]='F' OR [Gender]='M'))
GO
ALTER TABLE [clinical].[Patients] CHECK CONSTRAINT [CK_Patients_Gender]
GO
ALTER TABLE [hr].[DoctorSchedules]  WITH CHECK ADD CHECK  (([DayOfWeek]='Fri' OR [DayOfWeek]='Thu' OR [DayOfWeek]='Wed' OR [DayOfWeek]='Tue' OR [DayOfWeek]='Mon' OR [DayOfWeek]='Sun' OR [DayOfWeek]='Sat'))
GO
ALTER TABLE [hr].[DoctorSchedules]  WITH CHECK ADD  CONSTRAINT [CK_Sched_Times] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [hr].[DoctorSchedules] CHECK CONSTRAINT [CK_Sched_Times]
GO
ALTER TABLE [hr].[Nurses]  WITH CHECK ADD CHECK  (([ShiftType]='Night' OR [ShiftType]='Evening' OR [ShiftType]='Morning'))
GO
ALTER TABLE [hr].[Rooms]  WITH CHECK ADD CHECK  (([DailyRate]>(0)))
GO
ALTER TABLE [hr].[Rooms]  WITH CHECK ADD CHECK  (([RoomType]='Operation' OR [RoomType]='Private' OR [RoomType]='ICU' OR [RoomType]='General'))
GO
ALTER TABLE [hr].[Staff]  WITH CHECK ADD CHECK  (([Salary]>(0)))
GO
