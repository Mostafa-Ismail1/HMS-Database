# Hospital Management System (HMS) - Entity Relationship Diagrams

To ensure maximum clarity and readability on GitHub, the database architecture is presented through **focused domain diagrams** alongside an **executive high-level overview**.

---

## 1. Executive System Overview (Core Relationships)

A clear, uncrowded architectural view showing how the three core business domains interconnect:

```mermaid
erDiagram
    DEPARTMENTS ||--o{ DOCTORS : "employs"
    DEPARTMENTS ||--o{ ROOMS : "contains"
    DOCTORS ||--o{ APPOINTMENTS : "conducts"
    PATIENTS ||--o{ APPOINTMENTS : "attends"
    PATIENTS ||--o{ ADMISSIONS : "admitted to"
    ROOMS ||--o{ ADMISSIONS : "assigned to"
    DOCTORS ||--o{ ADMISSIONS : "attending physician"
    PATIENTS ||--o{ PRESCRIPTIONS : "receives"
    DOCTORS ||--o{ PRESCRIPTIONS : "prescribes"
    PATIENTS ||--o{ LAB_ORDERS : "tests"
    DOCTORS ||--o{ LAB_ORDERS : "orders"
    PATIENTS ||--o{ INVOICES : "billed to"
    ADMISSIONS ||--o| INVOICES : "originates"
    PATIENTS ||--o{ PATIENT_INSURANCE : "holds"
    INSURANCE_PROVIDERS ||--o{ PATIENT_INSURANCE : "issues"
```

---

## 2. Clinical Care Domain (`clinical` Schema)

Details the patient lifecycle, admissions, appointments, prescription details, and laboratory diagnostics:

```mermaid
erDiagram
    PATIENTS {
        int PatientID PK
        varchar FirstName
        varchar LastName
        date DOB
        varchar Phone
        char Gender
        datetime2 ValidFrom
        datetime2 ValidTo
    }

    APPOINTMENTS {
        int AppointmentID PK
        int PatientID FK
        int DoctorID FK
        datetime AppointmentDate
        varchar Status
        varchar Reason
    }

    ADMISSIONS {
        int AdmissionID PK
        int PatientID FK
        int RoomID FK
        int DoctorID FK
        datetime AdmissionDate
        datetime DischargeDate
    }

    PRESCRIPTIONS {
        int PrescriptionID PK
        int PatientID FK
        int DoctorID FK
        date DatePrescribed
    }

    PRESCRIPTION_DETAILS {
        int DetailID PK
        int PrescriptionID FK
        int MedicationID FK
        varchar Dosage
        varchar Frequency
        int DurationDays
    }

    MEDICATIONS {
        int MedicationID PK
        varchar MedicationName
        decimal UnitCost
    }

    LAB_ORDERS {
        int OrderID PK
        int PatientID FK
        int DoctorID FK
        int TestID FK
        date OrderDate
        varchar Status
    }

    LAB_TESTS {
        int TestID PK
        varchar TestName
        decimal Cost
    }

    PATIENTS ||--o{ APPOINTMENTS : "schedules"
    PATIENTS ||--o{ ADMISSIONS : "admitted"
    PATIENTS ||--o{ PRESCRIPTIONS : "prescribed to"
    PRESCRIPTIONS ||--o{ PRESCRIPTION_DETAILS : "contains"
    MEDICATIONS ||--o{ PRESCRIPTION_DETAILS : "specified in"
    PATIENTS ||--o{ LAB_ORDERS : "tested for"
    LAB_TESTS ||--o{ LAB_ORDERS : "defined by"
```

---

## 3. Human Resources & Hospital Facilities (`hr` Schema)

Details staff management, medical specialists, shift rosters, and patient rooms:

```mermaid
erDiagram
    DEPARTMENTS {
        int DepartmentID PK
        varchar DepartmentName
        varchar Location
    }

    STAFF {
        int StaffID PK
        varchar FirstName
        varchar LastName
        varchar Email
        varchar Phone
        date HireDate
        int DepartmentID FK
        varchar JobTitle
        decimal Salary
    }

    DOCTORS {
        int DoctorID PK
        int StaffID FK
        int DepartmentID FK
        varchar Specialization
        varchar LicenseNumber
    }

    NURSES {
        int NurseID PK
        int StaffID FK
        int DepartmentID FK
        varchar ShiftType
    }

    ROOMS {
        int RoomID PK
        varchar RoomNumber
        varchar RoomType
        int DepartmentID FK
        decimal DailyRate
    }

    DOCTOR_SCHEDULES {
        int ScheduleID PK
        int DoctorID FK
        varchar DayOfWeek
        time StartTime
        time EndTime
    }

    DEPARTMENTS ||--o{ STAFF : "employs"
    DEPARTMENTS ||--o{ DOCTORS : "houses"
    DEPARTMENTS ||--o{ NURSES : "assigns"
    DEPARTMENTS ||--o{ ROOMS : "manages"
    STAFF ||--|| DOCTORS : "clinical role"
    STAFF ||--|| NURSES : "nursing role"
    DOCTORS ||--o{ DOCTOR_SCHEDULES : "works shift"
```

---

## 4. Billing, Insurance & Audit Domain (`billing` Schema)

Details partitioned invoices, line items, patient insurance policies, and status change audit logs:

```mermaid
erDiagram
    INVOICES {
        int InvoiceID PK
        date IssueDate PK
        int PatientID FK
        int AdmissionID FK
        decimal TotalAmount
        varchar Status
    }

    INVOICE_ITEMS {
        int InvoiceItemID PK
        int InvoiceID FK
        date IssueDate FK
        varchar Description
        decimal Amount
    }

    INSURANCE_PROVIDERS {
        int ProviderID PK
        varchar ProviderName
        varchar ContactPhone
    }

    PATIENT_INSURANCE {
        int PatientID PK_FK
        int ProviderID PK_FK
        varchar PolicyNumber
        date ExpiryDate
    }

    INVOICE_STATUS_LOG {
        int LogID PK
        int InvoiceID FK
        varchar OldStatus
        varchar NewStatus
        datetime ChangedAt
    }

    INVOICES ||--o{ INVOICE_ITEMS : "itemized by"
    INVOICES ||--o{ INVOICE_STATUS_LOG : "audited into"
    INSURANCE_PROVIDERS ||--o{ PATIENT_INSURANCE : "contracts"
```

---
