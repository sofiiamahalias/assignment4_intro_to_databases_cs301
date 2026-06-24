create user financialDirector login password 'Finance5423!';
create user Doctor login password 'Kateryna123222@3!';
create user Admin login password 'Hosp$$12';

grant connect on database Ass4_db to financialDirector;
grant connect on database Ass4_db to Doctor;
grant connect on database Ass4_db to Admin;

grant usage on schema public to Admin;
grant usage on schema public to financialDirector;
grant usage on schema public to Doctor;

grant select, insert, update on Appointments, Patients to Doctor;
grant all privileges on all tables in schema public to Admin;
grant select, update on Finance to financialDirector;