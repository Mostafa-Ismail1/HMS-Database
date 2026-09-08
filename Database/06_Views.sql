/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 06_Views.sql
Description: Analytical and operational views for doctor workload, patient medical
             history, and invoice financial summaries.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- Operational and Analytical Views
-- =====================================================================================
/****** Object:  View [hr].[vw_DoctorWorkload]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================
-- ========================================================
-- Database Views & Reporting Layers
-- ========================================================
-- =====================================================================================
-- View: Doctor Workload Summary
CREATE   VIEW [hr].[vw_DoctorWorkload] AS
SELECT 
    d.DoctorID, 
    s.FirstName + ' ' + s.LastName AS DoctorName, 
    d.Specialization, 
    dep.DepartmentName, 
    COUNT(a.AppointmentID) AS TotalAppointments
FROM hr.Doctors d
JOIN hr.Staff s ON s.StaffID = d.DoctorID
JOIN hr.Departments dep ON dep.DepartmentID = s.DepartmentID
LEFT JOIN clinical.Appointments a ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID, s.FirstName, s.LastName, d.Specialization, dep.DepartmentName;
GO

/****** Object:  View [clinical].[vw_PatientFullHistory]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View: Patient Complete Medical History
CREATE   VIEW [clinical].[vw_PatientFullHistory] AS
SELECT 
    p.PatientID, 
    p.FirstName + ' ' + p.LastName AS PatientName, 
    a.AppointmentDate, 
    doc_s.FirstName + ' ' + doc_s.LastName AS SeenBy, 
    pr.PrescriptionID, 
    m.Name AS Medication, 
    pd.Dosage, 
    lo.ResultValue AS LabResult
FROM clinical.Patients p
LEFT JOIN clinical.Appointments a       ON a.PatientID = p.PatientID
LEFT JOIN hr.Doctors doc                ON doc.DoctorID = a.DoctorID
LEFT JOIN hr.Staff doc_s                ON doc_s.StaffID = doc.DoctorID
LEFT JOIN clinical.Prescriptions pr     ON pr.AppointmentID = a.AppointmentID
LEFT JOIN clinical.PrescriptionDetails pd ON pd.PrescriptionID = pr.PrescriptionID
LEFT JOIN clinical.Medications m        ON m.MedicationID = pd.MedicationID
LEFT JOIN clinical.LabOrders lo         ON lo.PatientID = p.PatientID;
GO

/****** Object:  View [billing].[vw_InvoiceTotals]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View: Invoice Financial Totals Summary
CREATE   VIEW [billing].[vw_InvoiceTotals] AS
SELECT 
    i.InvoiceID, 
    i.IssueDate, 
    i.PatientID, 
    i.Status, 
    SUM(ii.Amount) AS ComputedTotal
FROM billing.Invoices i
JOIN billing.InvoiceItems ii ON ii.InvoiceID = i.InvoiceID AND ii.IssueDate = i.IssueDate
GROUP BY i.InvoiceID, i.IssueDate, i.PatientID, i.Status;
GO
