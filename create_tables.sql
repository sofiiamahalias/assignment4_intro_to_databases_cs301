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

create table Procedures(
                           procedureID int primary key,
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
                      price int,
                      quantity int
);

--Створення процедури для заповнення двох колонок таблиці
create or replace procedure update_finance() --використано процедуру для коректного заповнення прибутку лікарень (при зміні даних можна викликати процедуру та значення оновляться)
language plpgsql
as $$
begin
update Finance f --оновлюємо необхідну таблицю
set income=( --для кожного рядка встановлюємо прибуток:
    select coalesce(sum(pr.price),0) --обчислюємо суму вартості всіх процедур (якщо їх немає, для уникання null використовуємо coalesce і додаємо 0)
    from Procedures pr --оскільки немає прямого зв'язку між лікарнею та процедурою, робимо два join через проміжні таблиці
             join Appointments a on pr.appointmentID=a.appointmentID --кожна процедура пов'язана з прийомом
             join Doctors d on a.doctorID=d.doctorID --прийом пов'язаний з лікарем (в лікаря є ID лікарні)
    where d.hospitalID=f.hospitalID
);
update Finance f
set avgIncome=(
    select coalesce(f.income/nullif(count(*),0),0) --використовуємо nullif щоб уникнути ділення на 0 (якщо немає пацієнтів, буде в клітинці null без помилки ділення на нуль, але coalesce замінить це на 0)
    from Patients p --з цієї таблиці отримуємо пацієнтів поточної лікарні та через count(*) рахуємо кількість пацієнтів лікарні
    where p.hospitalID=f.hospitalID
);
end;
$$;
call update_finance(); --виклик процедури

--Створення індексів для оптимізації
create index if not exists idx_procedures_appointment on Procedures(appointmentID); --створюємо індекси на колонки, які використовуються в join для оптимізації
create index if not exists idx_appointments_doctor on Appointments(doctorID);
create index if not exists idx_doctors_hospital on Doctors(hospitalID);

