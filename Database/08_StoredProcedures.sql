/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 08_StoredProcedures.sql
Description: Transactional stored procedures for patient admission, automated billing, 
             and monthly revenue reporting.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- Business Stored Procedures
-- =====================================================================================
/****** Object:  StoredProcedure [billing].[sp_BillAdmission]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure: Automatically generate invoice for an admission
CREATE   PROCEDURE [billing].[sp_BillAdmission]
    @AdmissionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PatientID INT, @RoomCost DECIMAL(10,2), @Days INT, @InvoiceID INT, @Today DATE = CAST(GETDATE() AS DATE);

    SELECT 
        @PatientID = a.PatientID, 
        @RoomCost  = r.DailyRate, 
        @Days      = DATEDIFF(DAY, a.AdmissionDate, ISNULL(a.DischargeDate, SYSDATETIME())) + 1
    FROM clinical.Admissions a
    JOIN hr.Rooms r ON r.RoomID = a.RoomID
    WHERE a.AdmissionID = @AdmissionID;

    INSERT INTO billing.Invoices (PatientID, AdmissionID, TotalAmount, IssueDate, Status)
    VALUES (@PatientID, @AdmissionID, 0, @Today, 'Unpaid');
    SET @InvoiceID = SCOPE_IDENTITY();

    INSERT INTO billing.InvoiceItems (InvoiceID, IssueDate, Description, Amount)
    VALUES (@InvoiceID, @Today, CONCAT('Room charge x', @Days, ' days'), @RoomCost * @Days);

    UPDATE billing.Invoices
    SET TotalAmount = (SELECT SUM(Amount) FROM billing.InvoiceItems WHERE InvoiceID = @InvoiceID AND IssueDate = @Today)
    WHERE InvoiceID = @InvoiceID AND IssueDate = @Today;

    PRINT 'Invoice ' + CAST(@InvoiceID AS VARCHAR) + ' generated for admission ' + CAST(@AdmissionID AS VARCHAR);
END
GO

/****** Object:  StoredProcedure [billing].[sp_MonthlyReport]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure: Monthly financial report using temporary aggregation tables
CREATE   PROCEDURE [billing].[sp_MonthlyReport] (@Year INT, @Month INT)
AS
BEGIN
    SET NOCOUNT ON;
    CREATE TABLE #MonthlyInvoices (
        InvoiceID INT, PatientName VARCHAR(100), TotalAmount DECIMAL(10,2)
    );

    INSERT INTO #MonthlyInvoices
    SELECT i.InvoiceID, p.FirstName + ' ' + p.LastName, i.TotalAmount
    FROM billing.Invoices i
    JOIN clinical.Patients p ON p.PatientID = i.PatientID
    WHERE YEAR(i.IssueDate) = @Year AND MONTH(i.IssueDate) = @Month;

    DECLARE @Summary TABLE (TotalRevenue DECIMAL(12,2), InvoiceCount INT);
    INSERT INTO @Summary SELECT SUM(TotalAmount), COUNT(*) FROM #MonthlyInvoices;

    SELECT * FROM #MonthlyInvoices;
    SELECT * FROM @Summary;

    DROP TABLE #MonthlyInvoices;
END
GO

/****** Object:  StoredProcedure [clinical].[sp_AdmitPatient]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================
-- ========================================================
-- Stored Procedures
-- ========================================================
-- =====================================================================================
-- Procedure: Admit patient to hospital room
CREATE   PROCEDURE [clinical].[sp_AdmitPatient]
    @PatientID INT,
    @RoomID INT,
    @DoctorID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM clinical.Admissions WITH (UPDLOCK, HOLDLOCK) 
                   WHERE RoomID = @RoomID AND DischargeDate IS NULL)
        BEGIN
            THROW 51001, 'Room is currently occupied.', 1;
        END

        INSERT INTO clinical.Admissions (PatientID, RoomID, AdmittingDoctorID, AdmissionDate)
        VALUES (@PatientID, @RoomID, @DoctorID, SYSDATETIME());

        COMMIT TRANSACTION;
        PRINT 'Patient admitted successfully. AdmissionID = ' + CAST(SCOPE_IDENTITY() AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'Admission failed: ' + ERROR_MESSAGE();
    END CATCH
END
GO
