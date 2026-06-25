create table Hospitals(
    hospitalID int primary key,
    maxQuantity int,
    rating decimal(3,2)
);
COMMENT ON TABLE Hospitals IS ' ';
COMMENT ON COLUMN Hospitals.hospitalID IS ' ';
COMMENT ON COLUMN Hospitals.maxQuantity IS ' ';
COMMENT ON COLUMN Hospitals.rating IS ' ';

        
create table Diagnosis (
    diagnosID int primary key,
    diagnos varchar(100),
    description varchar(100)
    );
COMMENT ON TABLE Diagnosis IS ' ';
COMMENT ON COLUMN Diagnosis.diagnosID IS ' ';
COMMENT ON COLUMN Diagnosis.diagnos IS ' ';
COMMENT ON COLUMN Diagnosis.description IS ' ';
  
        
create table Locations(
    hospitalID int primary key references Hospitals(hospitalID),
    city varchar(100),
    address varchar(100)
);
COMMENT ON TABLE Locations IS ' ';
COMMENT ON COLUMN Locations.hospitalID IS ' ';
COMMENT ON COLUMN Locations.city IS ' ';
COMMENT ON COLUMN Locations.address IS ' ';
        
        
create table Finance(
    hospitalID int primary key references Hospitals(hospitalID),
    income int default 0, --- suma procedure---
    avgIncome int default 0
);
COMMENT ON TABLE Finance IS ' ';
COMMENT ON COLUMN Finance.hospitalID IS ' ';
COMMENT ON COLUMN Finance.income IS ' ';
COMMENT ON COLUMN Finance.avgIncome IS ' ';


create table Patients(
	hospitalID int references Hospitals(hospitalID),
    patientID int primary key,
    patientName varchar(100),
    phone varchar(20)
);
COMMENT ON TABLE Patients IS ' ';
COMMENT ON COLUMN Patients.hospitalID IS ' ';
COMMENT ON COLUMN Patients.patientID IS ' ';
COMMENT ON COLUMN Patients.patientName IS ' ';
COMMENT ON COLUMN Patients.phone IS ' ';


create table Doctors(
	doctorID int primary key,
	hospitalID int references Hospitals(hospitalID),
    doctorName varchar(100),
    phone varchar(20),
    room int,
    speciality varchar(100)
);
COMMENT ON TABLE Doctors IS ' ';
COMMENT ON COLUMN Doctors.doctorID IS ' ';
COMMENT ON COLUMN Doctors.hospitalID IS ' ';
COMMENT ON COLUMN Doctors.doctorName IS ' ';
COMMENT ON COLUMN Doctors.phone IS ' ';
COMMENT ON COLUMN Doctors.room IS ' ';
COMMENT ON COLUMN Doctors.speciality IS ' ';


create table Appointments (
    appointmentID int primary key,
    patientID int references Patients(patientID),
    doctorID int references Doctors(doctorID),
    diagnosID int references Diagnosis(diagnosID),
    appointmentDate date
);
COMMENT ON TABLE Appointments IS ' ';
COMMENT ON COLUMN Appointments.appointmentID IS ' ';
COMMENT ON COLUMN Appointments.patientID IS ' ';
COMMENT ON COLUMN Appointments.doctorID IS ' ';
COMMENT ON COLUMN Appointments.diagnosID IS ' ';
COMMENT ON COLUMN Appointments.appointmentDate IS ' ';
        

create table Procedure(
    procedureID int primary key,
    description varchar(100),
    appointmentID int references Appointments(appointmentID),
    room int,
    price int
);
COMMENT ON TABLE Procedure IS ' ';
COMMENT ON COLUMN Procedure.procedureID IS ' ';
COMMENT ON COLUMN Procedure.descriptionID IS ' ';
COMMENT ON COLUMN Procedure.appointmentID IS ' ';
COMMENT ON COLUMN Procedure.room IS ' ';
COMMENT ON COLUMN Procedure.price IS ' ';


create table Pharmacy(
	medicineID int primary key,
    hospitalID int references Hospitals(hospitalID),
    medicineName varchar(100),
    medicineAllowed boolean default true,
    price int,
    quantity int
);
COMMENT ON TABLE Pharmacy IS ' ';
COMMENT ON COLUMN Pharmacy.medicineID IS ' ';
COMMENT ON COLUMN Pharmacy.hospitalID IS ' ';
COMMENT ON COLUMN Pharmacy.medicineName IS ' ';
COMMENT ON COLUMN Pharmacy.medicineAllowed IS ' ';
COMMENT ON COLUMN Pharmacy.price IS ' ';
COMMENT ON COLUMN Pharmacy.quantity IS ' ';      


create table Admin(
	itemID int primary key,
    hospitalID int references Hospitals(hospitalID),
    itemName varchar(100),
    allowed boolean default true,
    price int,
    quantity int
);
COMMENT ON TABLE Admin IS ' ';
COMMENT ON COLUMN Admin.itemID IS ' ';
COMMENT ON COLUMN Admin.hospitalID IS ' ';
COMMENT ON COLUMN Admin.itemName IS ' ';
COMMENT ON COLUMN Admin.allowed IS ' ';
COMMENT ON COLUMN Admin.price IS ' ';
COMMENT ON COLUMN Admin.quantity IS ' ';

--Create indexes
CREATE INDEX IF NOT EXISTS idx on ...; --TODO