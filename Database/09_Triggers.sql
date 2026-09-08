/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 09_Triggers.sql
Description: Database business validation and audit triggers: preventing appointment
             double-booking and logging invoice lifecycle status changes.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- Validation and Audit Triggers
-- =====================================================================================
/****** Object:  Trigger [billing].[trg_LogInvoiceStatusChange]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [billing].[trg_LogInvoiceStatusChange]
ON [billing].[Invoices]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        INSERT INTO billing.InvoiceStatusLog (InvoiceID, OldStatus, NewStatus)
        SELECT d.InvoiceID, d.Status, i.Status
        FROM inserted i
        JOIN deleted d ON d.InvoiceID = i.InvoiceID AND d.IssueDate = i.IssueDate
        WHERE d.Status <> i.Status;
    END
END
GO
ALTER TABLE [billing].[Invoices] ENABLE TRIGGER [trg_LogInvoiceStatusChange]
GO

/****** Object:  Trigger [clinical].[trg_PreventOverbooking]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================
-- ========================================================
-- Database Business & Audit Triggers
-- ========================================================
-- =====================================================================================
CREATE   TRIGGER [clinical].[trg_PreventOverbooking]
ON [clinical].[Appointments]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN clinical.Appointments a ON a.DoctorID = i.DoctorID 
           AND a.AppointmentDate = i.AppointmentDate 
           AND a.AppointmentID <> i.AppointmentID
    )
    BEGIN
        RAISERROR ('Doctor already has an appointment at this exact time.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO
ALTER TABLE [clinical].[Appointments] ENABLE TRIGGER [trg_PreventOverbooking]
GO
USE [master]
GO
ALTER DATABASE [HMS_DB] SET  READ_WRITE 
GO
