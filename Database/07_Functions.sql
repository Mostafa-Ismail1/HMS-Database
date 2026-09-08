/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 07_Functions.sql
Description: User-defined scalar and inline table-valued functions for patient age 
             calculation and doctor appointment schedule lookups.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- User Defined Functions
-- =====================================================================================
/****** Object:  UserDefinedFunction [clinical].[fn_GetPatientAge]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================
-- ========================================================
-- User Defined Functions
-- ========================================================
-- =====================================================================================
CREATE   FUNCTION [clinical].[fn_GetPatientAge] (@PatientID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SELECT @Age = DATEDIFF(YEAR, DOB, GETDATE()) - 
                  CASE WHEN (MONTH(DOB) > MONTH(GETDATE())) 
                         OR (MONTH(DOB) = MONTH(GETDATE()) AND DAY(DOB) > DAY(GETDATE())) 
                       THEN 1 ELSE 0 END
    FROM clinical.Patients WHERE PatientID = @PatientID;
    RETURN @Age;
END
GO

/****** Object:  UserDefinedFunction [clinical].[fn_GetDoctorAppointments]    Script Date: 9/8/2026 3:44:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [clinical].[fn_GetDoctorAppointments] (@DoctorID INT)
RETURNS TABLE
AS
RETURN (
    SELECT a.AppointmentID, p.FirstName + ' ' + p.LastName AS PatientName, a.AppointmentDate, a.Status
    FROM clinical.Appointments a
    JOIN clinical.Patients p ON p.PatientID = a.PatientID
    WHERE a.DoctorID = @DoctorID
);
GO
