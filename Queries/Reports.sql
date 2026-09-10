/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: Queries/Reports.sql
Description: Executive management reports including financial revenue, departmental 
             occupancy, and clinical testing metrics.
========================================================================================
*/

USE [HMS_DB];
GO

-- 1. Executive Financial Report: Billed, Collected, and Outstanding Revenue
SELECT 
    YEAR(IssueDate) AS BillingYear,
    MONTH(IssueDate) AS BillingMonth,
    COUNT(InvoiceID) AS TotalInvoices,
    SUM(CASE WHEN Status = 'Paid' THEN TotalAmount ELSE 0 END) AS CollectedRevenue,
    SUM(CASE WHEN Status = 'Unpaid' THEN TotalAmount ELSE 0 END) AS OutstandingRevenue,
    SUM(TotalAmount) AS GrossBilledAmount,
    CAST(ROUND((SUM(CASE WHEN Status = 'Paid' THEN TotalAmount ELSE 0 END) / NULLIF(SUM(TotalAmount), 0)) * 100, 2) AS DECIMAL(5,2)) AS CollectionRatePercentage
FROM billing.Invoices
GROUP BY YEAR(IssueDate), MONTH(IssueDate)
ORDER BY BillingYear DESC, BillingMonth DESC;
GO

-- 2. Departmental Bed & Admission Occupancy Report
SELECT 
    dep.DepartmentName,
    COUNT(DISTINCT r.RoomID) AS TotalRooms,
    COUNT(DISTINCT a.AdmissionID) AS TotalAdmissions,
    SUM(CASE WHEN a.DischargeDate IS NULL THEN 1 ELSE 0 END) AS CurrentlyOccupiedBeds,
    AVG(r.DailyRate) AS AverageDailyRate
FROM hr.Departments dep
LEFT JOIN hr.Rooms r ON dep.DepartmentID = r.DepartmentID
LEFT JOIN clinical.Admissions a ON r.RoomID = a.RoomID
GROUP BY dep.DepartmentName
ORDER BY TotalAdmissions DESC;
GO

-- 3. Laboratory Orders Status & Diagnostic Demand Summary
SELECT 
    lt.TestName,
    COUNT(lo.OrderID) AS TotalOrdersCount,
    SUM(CASE WHEN lo.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
    SUM(CASE WHEN lo.Status = 'Pending' THEN 1 ELSE 0 END) AS PendingOrders,
    SUM(lt.Cost) AS GrossDiagnosticRevenue
FROM clinical.LabTests lt
LEFT JOIN clinical.LabOrders lo ON lt.TestID = lo.TestID
GROUP BY lt.TestName
ORDER BY TotalOrdersCount DESC;
GO

-- 4. Physician Consultation & Clinical Workload Performance
SELECT 
    vw.DoctorID,
    vw.DoctorName,
    vw.Specialization,
    vw.TotalAppointments,
    vw.CompletedAppointments,
    vw.AdmittedPatients
FROM hr.vw_DoctorWorkload vw
ORDER BY vw.TotalAppointments DESC;
GO
