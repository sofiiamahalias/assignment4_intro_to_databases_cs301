create table Hospitals(
    hospitalID int primary key,
    maxQuantity int,
    rating decimal(3,2)
);
create table Diagnosis (
    diagnosID int primary key,
    diagnos varchar(100),
    description varchar(100)
    );
create table Locations(
    hospitalID int primary key references Hospitals(hospitalID),
    city varchar(100),
    address varchar(100)
);
create table Finance(
    hospitalID int primary key references Hospitals(hospitalID),
    income int default 0, --- suma procedure---
    avgIncome int default 0
);
create table Patients(
	hospitalID int references Hospitals(hospitalID),
    patientID int primary key,
    patientName varchar(100),
    phone varchar(20)
);
create table Doctors(
	doctorID int primary key,
	hospitalID int references Hospitals(hospitalID),
    doctorName varchar(100),
    phone varchar(20),
    room int,
    speciality varchar(100)
);
create table Appointments (
    appointmentID int primary key,
    patientID int references Patients(patientID),
    doctorID int references Doctors(doctorID),
    diagnosID int references Diagnosis(diagnosID),
    appointmentDate date
);
create table Procedure(
    procedureID int primary key,
    description varchar(100),
    appointmentID int references Appointments(appointmentID),
    room int,
    price int
);
create table Pharmacy(
	medicineID int primary key,
    hospitalID int references Hospitals(hospitalID),
    medicineName varchar(100),
    medicineAllowed boolean default true,
    price int,
    quantity int
);
create table Admin(
	itemID int primary key,
    hospitalID int references Hospitals(hospitalID),
    itemName varchar(100),
    allowed boolean default true,
    price int,
    quantity int
);