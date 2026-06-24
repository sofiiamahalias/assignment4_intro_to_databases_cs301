create table Patients(
	hospitalid int,
    PatientID int primary key,
    PatientName varchar(100),
    MedicalNotes varchar(100),
    Phone varchar(20)
);
create table Doctors(
	hospitalid int,
    DoctorID int primary key,
    DoctorName varchar(100),
    Phone varchar(20),
    Room int,
    Speciality varchar(100)
);
create table Diagnosis (
    DiagnosID int primary key,
    Diagnos varchar(100),
    Description varchar(100)
    );
create table Appointments (
    AppointmentID int primary key,
    PatientID int,
    DoctorID int,
    DiagnosID int,
    Date date
);
create table Procedure(
    ProcedureID int primary key,
    Description varchar(100),
    AppointmentID int,
    Room int,
    Price int
);
create table Locations(
    hospitalid int primary key,
    city varchar(100),
    address varchar(100)
);
create table Hospitals(
    id int primary key,
    max_quantity int,
    rating decimal
);
create table Finance(
    hospitalid int primary key,
    income int, --- suma procedure---
    avg_income int
);
create table Pharmacy(
	id int primary key,
    hospitalid int,
    id int primary key,
    allowed boolean default true,
    Price int,
    quantity int
);
create table Admin(
	item_id int primary key,
    hospitalid int,
    item_name varchar(100),
    allowed boolean default true,
    Price int,
    quantity int
);