/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: Queries/AdvancedQueries.sql
Description: Advanced SQL queries utilizing System-Versioned Temporal Tables, 
             Window Functions, CTEs, and Partition Analysis.
========================================================================================
*/

USE [HMS_DB];
GO

-- 1. Temporal Audit: Track historical patient profile changes using SYSTEM_TIME ALL
SELECT 
    PatientID,
    FirstName + ' ' + LastName AS PatientName,
    Phone,
    Email,
    Address,
    ValidFrom,
    ValidTo,
    CASE 
        WHEN ValidTo >= '9999-12-31' THEN 'Current Active Record'
        ELSE 'Historical Snapshot'
    END AS RecordStatus
FROM clinical.Patients FOR SYSTEM_TIME ALL
WHERE PatientID IN (1, 2, 3)
ORDER BY PatientID, ValidFrom ASC;
GO

-- 2. Window Function: Ranking Doctors by Appointment Volume per Department
WITH DoctorApptCounts AS (
    SELECT 
        d.DoctorID,
        s.FirstName + ' ' + s.LastName AS DoctorName,
        dep.DepartmentName,
        COUNT(a.AppointmentID) AS TotalAppointments
    FROM hr.Doctors d
    JOIN hr.Staff s ON d.StaffID = s.StaffID
    JOIN hr.Departments dep ON d.DepartmentID = dep.DepartmentID
    LEFT JOIN clinical.Appointments a ON d.DoctorID = a.DoctorID
    GROUP BY d.DoctorID, s.FirstName, s.LastName, dep.DepartmentName
)
SELECT 
    DepartmentName,
    DoctorName,
    TotalAppointments,
    DENSE_RANK() OVER (PARTITION BY DepartmentName ORDER BY TotalAppointments DESC) AS RankInDepartment
FROM DoctorApptCounts;
GO

-- 3. Recursive CTE & Running Totals: Cumulative Revenue by Billing Month
WITH MonthlyRevenue AS (
    SELECT 
        DATEFROMPARTS(YEAR(IssueDate), MONTH(IssueDate), 1) AS BillingMonth,
        SUM(TotalAmount) AS MonthlyTotal
    FROM billing.Invoices
    WHERE Status = 'Paid'
    GROUP BY DATEFROMPARTS(YEAR(IssueDate), MONTH(IssueDate), 1)
)
SELECT 
    BillingMonth,
    MonthlyTotal,
    SUM(MonthlyTotal) OVER (ORDER BY BillingMonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeRevenue
FROM MonthlyRevenue;
GO

-- 4. Partition Scheme Analysis: Distribution of Invoices Across Annual Partitions
SELECT 
    p.partition_number AS PartitionNumber,
    prv.value AS BoundaryDate,
    p.rows AS RecordCount
FROM sys.partitions p
JOIN sys.tables t ON p.object_id = t.object_id
JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
LEFT JOIN sys.partition_range_values prv 
    ON ps.function_id = prv.function_id AND p.partition_number = prv.boundary_id
WHERE t.name = 'Invoices'
ORDER BY p.partition_number;
GO
