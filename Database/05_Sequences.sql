/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 05_Sequences.sql
Description: Database sequence generators for billing and identifier numbering.
========================================================================================
*/

USE [HMS_DB]
GO

-- =====================================================================================
-- Database Sequences
-- =====================================================================================
/****** Object:  Sequence [billing].[InvoiceRefSeq]    Script Date: 9/8/2026 3:44:25 PM ******/
CREATE SEQUENCE [billing].[InvoiceRefSeq] 
 AS [int]
 START WITH 1000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
