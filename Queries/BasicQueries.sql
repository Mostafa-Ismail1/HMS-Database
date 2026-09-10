/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: Queries/BasicQueries.sql
Description: Foundational queries for daily hospital administration, appointments, 
             billing status, and patient lookups.
========================================================================================
*/

USE [HMS_DB];
GO

-- 1. Active Doctor Directory with Departments and Base Salary
SELECT 
    d.DoctorID,
    s.FirstName + ' ' + s.LastName AS DoctorName,
    s.Email,
    s.Phone,
    dep.DepartmentName,
    d.Specialization,
    d.LicenseNumber,
    s.Salary
FROM hr.Doctors d
JOIN hr.Staff s ON d.StaffID = s.StaffID
JOIN hr.Departments dep ON d.DepartmentID = dep.DepartmentID
ORDER BY dep.DepartmentName, DoctorName;
GO

-- 2. Daily Patient Appointment Schedule
SELECT 
    a.AppointmentID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    p.Phone AS PatientPhone,
    s.FirstName + ' ' + s.LastName AS DoctorName,
    dep.DepartmentName,
    a.AppointmentDate,
    a.Status AS AppointmentStatus,
    a.Reason
FROM clinical.Appointments a
JOIN clinical.Patients p ON a.PatientID = p.PatientID
JOIN hr.Doctors d ON a.DoctorID = d.DoctorID
JOIN hr.Staff s ON d.StaffID = s.StaffID
JOIN hr.Departments dep ON d.DepartmentID = dep.DepartmentID
ORDER BY a.AppointmentDate DESC;
GO

-- 3. Outstanding Unpaid Invoices with Insurance Coverage
SELECT 
    i.InvoiceID,
    i.IssueDate,
    p.FirstName + ' ' + p.LastName AS PatientName,
    i.TotalAmount,
    i.Status,
    ip.ProviderName AS InsuranceProvider,
    pi.PolicyNumber
FROM billing.Invoices i
JOIN clinical.Patients p ON i.PatientID = p.PatientID
LEFT JOIN billing.PatientInsurance pi ON p.PatientID = pi.PatientID
LEFT JOIN billing.InsuranceProviders ip ON pi.ProviderID = ip.ProviderID
WHERE i.Status = 'Unpaid'
ORDER BY i.IssueDate ASC;
GO

-- 4. Available Hospital Rooms and Rates by Department
SELECT 
    r.RoomID,
    r.RoomNumber,
    r.RoomType,
    dep.DepartmentName,
    r.DailyRate
FROM hr.Rooms r
JOIN hr.Departments dep ON r.DepartmentID = dep.DepartmentID
ORDER BY dep.DepartmentName, r.RoomNumber;
GO

-- 5. Prescriptions with Medication and Dosage Details
SELECT 
    pr.PrescriptionID,
    p.FirstName + ' ' + p.LastName AS PatientName,
    s.FirstName + ' ' + s.LastName AS PrescribingDoctor,
    pr.DatePrescribed,
    m.MedicationName,
    pd.Dosage,
    pd.Frequency,
    pd.DurationDays
FROM clinical.Prescriptions pr
JOIN clinical.Patients p ON pr.PatientID = p.PatientID
JOIN hr.Doctors d ON pr.DoctorID = d.DoctorID
JOIN hr.Staff s ON d.StaffID = s.StaffID
JOIN clinical.PrescriptionDetails pd ON pr.PrescriptionID = pd.PrescriptionID
JOIN clinical.Medications m ON pd.MedicationID = m.MedicationID
ORDER BY pr.DatePrescribed DESC;
GO
