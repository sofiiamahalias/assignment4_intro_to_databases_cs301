create table Hospitals( --Таблиця всіх лікарень--
                          hospitalID int primary key, --Первинний ключ ID лікарні--
                          maxQuantity int not null, --Максимальна місткість пацієнтів--
                          rating decimal(3,2),
                          constraint chk_hospital_maxQuantity check(maxQuantity>0), --Обмеження містткість від 0--
                          constraint chk_hospital_rating check (rating>=0.0 and rating<=5.0) --Обмеження рейтинг від 0.0 до 5.0--
);

create table Diagnosis (--таблиця з діагнозами--
                           diagnosID int primary key, --Первинний ключ по діагноз ID--
                           diagnos varchar(100) not null,
                           description varchar(100) --Опис хвороби--
);

create table Locations(--Таблиця з усіма локаціями лікарень--
                          hospitalID int primary key references Hospitals(hospitalID), --ID лікарні тут зв'язок 1:1--
                          city varchar(100) not null, --Місто не нуль--
                          address varchar(100) not null,
                          constraint locations_address unique (address)--Обмеження, що адреси унікальні--
);

create table Finance(--Таблиця з фінансами по лікарням--
                        hospitalID int primary key references Hospitals(hospitalID), -- Ідентифікатор лікарні зв'язок 1:1--
                        income decimal(10,2) default 0.0, --Прибуток лікарні початково 0--
                        avgIncome decimal(10,2) default 0.0, --Середній прибуток - загальний/кількість пацієнтів--
                        constraint chk_finance_income check (income>=0), --Обмеження прибуток більший рівний нулю--
                        constraint chk_finance_avgIncome check (avgIncome>=0)
);

create table Patients(--Таблиця усіх пацієнтів--
                         hospitalID int references Hospitals(hospitalID), -- ID лікарні до якої прикріплений пацієнт 1:M--
                         patientID int primary key, --Первинний ключ--
                         patientName varchar(100) not null,
                         phone varchar(20) not null,
                         constraint patients_phone unique (phone) --Обмеження телефон тільки унікальний--
);

create table Doctors(--Таблиця усіх лікарів--
                        doctorID int primary key, --Первинний ключ ID--
                        hospitalID int references Hospitals(hospitalID),--Зовнішній ключ прив'язаний до локації лікарні 1:M--
                        doctorName varchar(100) not null,--Не нуль ім'я--
                        phone varchar(20),
                        room int,
                        speciality varchar(100) not null,
                        constraint doctors_phone unique (phone), --Унікальний номер--
                        constraint chk_doctors_room check (room>0)--Номер кімнати більший за нуль--
);

create table Appointments (--Таблиця усіх записів--
                              appointmentID int primary key,--Первинний ключ--
                              patientID int references Patients(patientID), --Зв'язок 1:M--
                              doctorID int references Doctors(doctorID),--Зв'язок 1:M--
                              diagnosID int references Diagnosis(diagnosID),--Зв'язок 1:M--
                              appointmentDate date not null --Дата не нуль--
);

create table Procedures(--Таблиця усіх можливих процедур--
                           procedureID int primary key,
                           appointmentID int references Appointments(appointmentID),--Зв'язок 1:M--
                           room int,
                           price decimal(10,2) not null,
                           constraint chk_procedures_price check (price>=0),
                           constraint chk_procedures_room check (room>0)
);

create table Pharmacy(--Таблиця аптеки--
                         medicineID int primary key,
                         hospitalID int references Hospitals(hospitalID),--Зв'язок 1:M--
                         medicineName varchar(100) not null,
                         medicineAllowed boolean default true,--Початково правда--
                         price decimal (10,2) not null,
                         quantity int default 0,--Початкова кількість 0--
                         constraint chk_pharmacy_price check (price>0),
                         constraint chk_pharmacy_quantity check (quantity>=0)
);

create table Admin(--Таблиця Адміна--
                      itemID int primary key,
                      hospitalID int references Hospitals(hospitalID),--Зв'язок 1:M--
                      itemName varchar(100) not null,
                      price decimal(10,2) not null,
                      quantity int default 0,
                      constraint chk_admin_price check (price>=0),--Вартість більша рівна нулю--
                      constraint chk_admin_quantity check (quantity>=0)--Обмеження кількість більша рівна нулю--
);
create table Appointment_Medicines(--Таблиця для призначення ліків на записі--
	appointmentID int references Appointments(appointmentID),--Зв'язок M:M тут може бути декілька видів ліків за один прийом або один вид на декілька прийомів--
	medicineID int references Pharmacy(medicineID),
	quantity int default 1,
	constraint chk_app_med check (quantity>0),
	primary key (appointmentID, medicineID)
);


--Створення процедури для заповнення двох колонок таблиці
create or replace procedure update_finance() --використано процедуру для коректного заповнення прибутку лікарень (при зміні даних можна викликати процедуру та значення оновляться)
language plpgsql
as $$
begin
update Finance f --оновлюємо необхідну таблицю
set income=( --для кожного рядка встановлюємо прибуток:
    select coalesce(sum(pr.price),0.0) --обчислюємо суму вартості всіх процедур (якщо їх немає, для уникання null використовуємо coalesce і додаємо 0)
    from Procedures pr --оскільки немає прямого зв'язку між лікарнею та процедурою, робимо два join через проміжні таблиці
             join Appointments a on pr.appointmentID=a.appointmentID --кожна процедура пов'язана з прийомом
             join Doctors d on a.doctorID=d.doctorID --прийом пов'язаний з лікарем (в лікаря є ID лікарні)
    where d.hospitalID=f.hospitalID
);
update Finance f
set avgIncome=(
    select coalesce(f.income/nullif(count(*),0.0),0.0) --використовуємо nullif щоб уникнути ділення на 0 (якщо немає пацієнтів, буде в клітинці null без помилки ділення на нуль, але coalesce замінить це на 0)
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
--Тестування індексів (оскільки вони були створені для колонок з join, використовую саме цю частину процедури (обчислення прибутку) для перевірки ефективності)
explain analyze
select coalesce(sum(pr.price), 0.0)
from Procedures pr
join Appointments a on pr.appointmentID = a.appointmentID
join Doctors d on a.doctorID = d.doctorID
where d.hospitalID = 1;
--Отримала такі результати 
--Без індексів: Planning Time: 13.122 ms        Execution Time: 183.821 ms  
--З трьома індексами: Planning Time: 3.960 ms    Execution Time: 83.672 ms