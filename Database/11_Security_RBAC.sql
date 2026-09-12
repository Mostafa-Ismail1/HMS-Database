/*
========================================================================================
Project: Hospital Management System (HMS_DB)
File: 11_Security_RBAC.sql
Description: Enterprise Role-Based Access Control (RBAC) configuration. Defines granular 
             GRANT and DENY permissions for administrative, reception, clinical, nursing, 
             and accounting personnel, provisions database users, and assigns role memberships.
========================================================================================
*/

USE [HMS_DB];
GO

-- =====================================================================================
-- 1. Database Role Provisioning
-- =====================================================================================

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_hospital_director' AND type = 'R')
BEGIN
    CREATE ROLE [db_hospital_director];
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_reception' AND type = 'R')
BEGIN
    CREATE ROLE [db_reception];
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_clinical_staff' AND type = 'R')
BEGIN
    CREATE ROLE [db_clinical_staff];
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_nursing_staff' AND type = 'R')
BEGIN
    CREATE ROLE [db_nursing_staff];
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'db_accounting' AND type = 'R')
BEGIN
    CREATE ROLE [db_accounting];
END;
GO

-- =====================================================================================
-- 2. Role Permissions Matrix (GRANT & DENY)
-- =====================================================================================

-----------------------------------------------------------------------------------------
-- Role: db_hospital_director (Full Administrative Control)
-----------------------------------------------------------------------------------------
GRANT CONTROL ON DATABASE::[HMS_DB] TO [db_hospital_director];
GO

-----------------------------------------------------------------------------------------
-- Role: db_reception (Front Desk & Patient Intake)
-----------------------------------------------------------------------------------------
-- Granted Permissions: Patient registration, appointments, room & doctor lookups, insurance
GRANT SELECT, INSERT, UPDATE ON [clinical].[Patients] TO [db_reception];
GRANT SELECT, INSERT, UPDATE ON [clinical].[Appointments] TO [db_reception];
GRANT SELECT ON [hr].[DoctorSchedules] TO [db_reception];
GRANT SELECT ON [hr].[Doctors] TO [db_reception];
GRANT SELECT ON [hr].[Rooms] TO [db_reception];
GRANT SELECT, INSERT ON [billing].[PatientInsurance] TO [db_reception];

-- Explicit Denials: Medical prescriptions, lab orders, billing invoices, staff HR records
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[Prescriptions] TO [db_reception];
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[PrescriptionDetails] TO [db_reception];
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[LabOrders] TO [db_reception];
DENY SELECT, INSERT, UPDATE, DELETE ON [billing].[Invoices] TO [db_reception];
DENY SELECT, INSERT, UPDATE, DELETE ON [billing].[InvoiceItems] TO [db_reception];
DENY SELECT, INSERT, UPDATE, DELETE ON [hr].[Staff] TO [db_reception];
GO

-----------------------------------------------------------------------------------------
-- Role: db_clinical_staff (Attending Physicians / Doctors)
-----------------------------------------------------------------------------------------
-- Revoke prior broad schema authorizations if present
REVOKE INSERT ON SCHEMA::[clinical] FROM [db_clinical_staff];
REVOKE SELECT ON SCHEMA::[clinical] FROM [db_clinical_staff];
REVOKE UPDATE ON SCHEMA::[clinical] FROM [db_clinical_staff];
REVOKE SELECT ON SCHEMA::[hr] FROM [db_clinical_staff];

-- Granted Permissions: Patient history, appointments, prescription orders, lab requests, admissions
GRANT SELECT ON [clinical].[Patients] TO [db_clinical_staff];
GRANT SELECT ON [clinical].[Appointments] TO [db_clinical_staff];
GRANT SELECT, INSERT, UPDATE ON [clinical].[Prescriptions] TO [db_clinical_staff];
GRANT SELECT, INSERT, UPDATE ON [clinical].[PrescriptionDetails] TO [db_clinical_staff];
GRANT SELECT, INSERT, UPDATE ON [clinical].[LabOrders] TO [db_clinical_staff];
GRANT SELECT, INSERT, UPDATE ON [clinical].[Admissions] TO [db_clinical_staff];
GRANT SELECT ON [clinical].[Medications] TO [db_clinical_staff];
GRANT SELECT ON [clinical].[LabTests] TO [db_clinical_staff];

-- Explicit Denials: Financial modifications, patient deletion, HR salary records
DENY INSERT, UPDATE, DELETE ON SCHEMA::[billing] TO [db_clinical_staff];
DENY DELETE ON [clinical].[Patients] TO [db_clinical_staff];
DENY SELECT, INSERT, UPDATE, DELETE ON [hr].[Staff] TO [db_clinical_staff];
GO

-----------------------------------------------------------------------------------------
-- Role: db_nursing_staff (Inpatient Care & Treatment Administration)
-----------------------------------------------------------------------------------------
-- Granted Permissions: Patient view, medication instructions, admission bed status, lab viewing
GRANT SELECT ON [clinical].[Patients] TO [db_nursing_staff];
GRANT SELECT ON [clinical].[Prescriptions] TO [db_nursing_staff];
GRANT SELECT ON [clinical].[PrescriptionDetails] TO [db_nursing_staff];
GRANT SELECT, UPDATE ON [clinical].[Admissions] TO [db_nursing_staff];
GRANT SELECT, UPDATE ON [hr].[Rooms] TO [db_nursing_staff];
GRANT SELECT ON [clinical].[LabOrders] TO [db_nursing_staff];
GRANT SELECT ON [clinical].[Medications] TO [db_nursing_staff];

-- Explicit Denials: Prescription alteration/creation, financial records, medical record deletion
DENY INSERT, UPDATE, DELETE ON [clinical].[Prescriptions] TO [db_nursing_staff];
DENY INSERT, UPDATE, DELETE ON [clinical].[PrescriptionDetails] TO [db_nursing_staff];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[billing] TO [db_nursing_staff];
DENY DELETE ON SCHEMA::[clinical] TO [db_nursing_staff];
DENY SELECT, INSERT, UPDATE, DELETE ON [hr].[Staff] TO [db_nursing_staff];
GO

-----------------------------------------------------------------------------------------
-- Role: db_accounting (Financial Management & Billing)
-----------------------------------------------------------------------------------------
-- Granted Permissions: Full billing domain operations, admission duration and appointment lookups
GRANT SELECT, INSERT, UPDATE ON SCHEMA::[billing] TO [db_accounting];
GRANT SELECT ON [clinical].[Admissions] TO [db_accounting];
GRANT SELECT ON [clinical].[Appointments] TO [db_accounting];

-- Explicit Denials: Confidential clinical diagnosis, prescriptions, and lab test results
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[Prescriptions] TO [db_accounting];
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[PrescriptionDetails] TO [db_accounting];
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[LabOrders] TO [db_accounting];
DENY SELECT, INSERT, UPDATE, DELETE ON [clinical].[Patients] TO [db_accounting];
GO

-- =====================================================================================
-- 3. Database User Provisioning (WITHOUT LOGIN for Simulation & Internal Access)
-- =====================================================================================

-- Reception Staff Users
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Recep_Nour')
    CREATE USER [User_Recep_Nour] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Recep_Youssef')
    CREATE USER [User_Recep_Youssef] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Recep_Mariam')
    CREATE USER [User_Recep_Mariam] WITHOUT LOGIN;

-- Nursing Staff Users
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Nurse_Salma')
    CREATE USER [User_Nurse_Salma] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Nurse_Fatma')
    CREATE USER [User_Nurse_Fatma] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Nurse_Aya')
    CREATE USER [User_Nurse_Aya] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Nurse_Mona')
    CREATE USER [User_Nurse_Mona] WITHOUT LOGIN;

-- Clinical Staff / Doctor Users
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Ahmed')
    CREATE USER [User_Dr_Ahmed] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Gamal')
    CREATE USER [User_Dr_Gamal] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Tamer')
    CREATE USER [User_Dr_Tamer] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Amar')
    CREATE USER [User_Dr_Amar] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Mostafa')
    CREATE USER [User_Dr_Mostafa] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Dr_Waled')
    CREATE USER [User_Dr_Waled] WITHOUT LOGIN;

-- Executive & Accounting Users
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Director')
    CREATE USER [User_Director] WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'User_Accountant_Khaled')
    CREATE USER [User_Accountant_Khaled] WITHOUT LOGIN;
GO

-- =====================================================================================
-- 4. Role Membership Assignment
-- =====================================================================================

-- Executive Director Role
ALTER ROLE [db_hospital_director] ADD MEMBER [User_Director];

-- Reception Role
ALTER ROLE [db_reception] ADD MEMBER [User_Recep_Nour];
ALTER ROLE [db_reception] ADD MEMBER [User_Recep_Youssef];
ALTER ROLE [db_reception] ADD MEMBER [User_Recep_Mariam];

-- Nursing Role
ALTER ROLE [db_nursing_staff] ADD MEMBER [User_Nurse_Salma];
ALTER ROLE [db_nursing_staff] ADD MEMBER [User_Nurse_Fatma];
ALTER ROLE [db_nursing_staff] ADD MEMBER [User_Nurse_Aya];
ALTER ROLE [db_nursing_staff] ADD MEMBER [User_Nurse_Mona];

-- Clinical Role
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Ahmed];
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Gamal];
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Tamer];
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Amar];
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Mostafa];
ALTER ROLE [db_clinical_staff] ADD MEMBER [User_Dr_Waled];

-- Accounting Role
ALTER ROLE [db_accounting] ADD MEMBER [User_Accountant_Khaled];
GO

-- =====================================================================================
-- 5. Verification & Security Audit Queries
-- =====================================================================================

-- Audit Role Memberships
SELECT 
    r.name AS RoleName,
    m.name AS MemberUserName,
    m.type_desc AS MemberType
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('db_hospital_director', 'db_reception', 'db_clinical_staff', 'db_nursing_staff', 'db_accounting')
ORDER BY r.name, m.name;

-- Audit Role Permissions (GRANT / DENY)
SELECT 
    r.name AS RoleName,
    p.state_desc AS PermissionState,
    p.permission_name AS PermissionName,
    CASE 
        WHEN p.class = 0 THEN 'DATABASE::HMS_DB'
        WHEN p.class = 3 THEN 'SCHEMA::' + SCHEMA_NAME(p.major_id)
        WHEN p.class = 1 THEN OBJECT_SCHEMA_NAME(p.major_id) + '.' + OBJECT_NAME(p.major_id)
        ELSE CAST(p.major_id AS VARCHAR(20))
    END AS SecurableObject
FROM sys.database_permissions p
JOIN sys.database_principals r ON p.grantee_principal_id = r.principal_id
WHERE r.name IN ('db_hospital_director', 'db_reception', 'db_clinical_staff', 'db_nursing_staff', 'db_accounting')
ORDER BY RoleName, SecurableObject, p.permission_name;
GO
