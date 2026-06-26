create user financialDirector with password 'Finance5423!';
create user Doctor with password 'Kateryna123222@3!';
create user AdminHosp with password 'Hosp$$12';

grant connect on database Ass4_db to financialDirector;
grant connect on database Ass4_db to Doctor;
grant connect on database Ass4_db to AdminHosp;

grant usage on schema public to AdminHosp;
grant usage on schema public to financialDirector;
grant usage on schema public to Doctor;

grant select, insert, update on Appointments, Patients, Procedures, Appointment_Medicines to Doctor;
grant select on Doctors, Diagnosis, Pharmacy to Doctor;

grant all privileges on all tables in schema public to AdminHosp;
grant all privileges on all sequences in schema public to AdminHosp;

grant select, update on Finance to financialDirector;
grant select on Hospitals, Locations to financialDirector;
