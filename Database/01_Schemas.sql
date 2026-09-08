/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 01_Schemas.sql
Description: Database creation, security roles, schemas, partition functions/schemes, 
             and synonyms.
========================================================================================
*/

USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'HMS_DB')
BEGIN
    CREATE DATABASE [HMS_DB];
END
GO

USE [HMS_DB]
GO

-- =====================================================================================
-- 1. Database Security Roles
-- =====================================================================================
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_reception' AND type = 'R')
    CREATE ROLE [db_reception]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_clinical_staff' AND type = 'R')
    CREATE ROLE [db_clinical_staff]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'db_accounting' AND type = 'R')
    CREATE ROLE [db_accounting]
GO

-- =====================================================================================
-- 2. Database Schemas
-- =====================================================================================
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'billing')
    EXEC('CREATE SCHEMA [billing]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'clinical')
    EXEC('CREATE SCHEMA [clinical]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'hr')
    EXEC('CREATE SCHEMA [hr]')
GO

-- =====================================================================================
-- 3. Partitioning: Function and Scheme
-- =====================================================================================
IF NOT EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'PF_InvoiceYear')
BEGIN
    CREATE PARTITION FUNCTION [PF_InvoiceYear](date) 
    AS RANGE RIGHT FOR VALUES (N'2024-01-01', N'2025-01-01', N'2026-01-01', N'2027-01-01')
END
GO

IF NOT EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'PS_InvoiceYear')
BEGIN
    CREATE PARTITION SCHEME [PS_InvoiceYear] 
    AS PARTITION [PF_InvoiceYear] ALL TO ([PRIMARY])
END
GO

-- =====================================================================================
-- 4. Database Synonyms
-- =====================================================================================
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'syn_Invoices')
    CREATE SYNONYM [dbo].[syn_Invoices] FOR [HMS_DB].[billing].[Invoices]
GO

IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = N'syn_Patients')
    CREATE SYNONYM [dbo].[syn_Patients] FOR [HMS_DB].[clinical].[Patients]
GO
