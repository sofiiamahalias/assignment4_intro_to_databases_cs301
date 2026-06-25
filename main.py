#скрипт згенерований ШІ
import random
from datetime import date,timedelta

import psycopg2
from psycopg2.extras import execute_batch
from faker import Faker

fake=Faker()

host="localhost"
port="5432"
database="assignment4"
user="postgres"
password="54321"

batch_size=5000

def create_connection():
return psycopg2.connect(
host=host,
port=port,
dbname=database,
user=user,
password=password
)

def insert_batch(connection,query,data):
with connection.cursor() as cur:
execute_batch(cur,query,data,page_size=1000)
connection.commit()

def generate_hospitals(conn):
q="""
insert into hospitals
(hospitalid,maxquantity,rating)
values (%s,%s,%s)
"""
data=[]
for i in range(1,101):
data.append((
i,
random.randint(50,5000),
round(random.uniform(1,5),2)
))
insert_batch(conn,q,data)

def generate_locations(conn):
q="""
insert into locations
(hospitalid,city,address)
values (%s,%s,%s)
"""
data=[]
for i in range(1,101):
data.append((
i,
fake.city(),
fake.street_address()
))
insert_batch(conn,q,data)

def generate_finance(conn):
q="""
insert into finance
(hospitalid)
values (%s)
"""
data=[(i,) for i in range(1,101)]
insert_batch(conn,q,data)

def generate_diagnosis(conn):
diagnoses=[
("Influenza","Viral respiratory infection"),
("COVID-19","Coronavirus infection"),
("Diabetes","Blood sugar disorder"),
("Asthma","Chronic airway inflammation"),
("Hypertension","High blood pressure"),
("Migraine","Severe recurring headache"),
("Fracture","Broken bone"),
("Pneumonia","Lung infection"),
("Bronchitis","Inflamed bronchial tubes"),
("Appendicitis","Inflamed appendix"),
("Gastritis","Stomach lining inflammation"),
("Arthritis","Joint inflammation"),
("Allergy","Immune system reaction"),
("Otitis","Ear infection"),
("Dermatitis","Skin inflammation"),
("Anemia","Low red blood cells"),
("Depression","Mood disorder"),
("Epilepsy","Neurological seizure disorder"),
("Kidney Stones","Mineral deposits in kidneys"),
("Heart Failure","Reduced heart function")
]

```
q="""
insert into diagnosis
(diagnosid,diagnos,description)
values (%s,%s,%s)
"""

data=[]
for i,item in enumerate(diagnoses,start=1):
    data.append((i,item[0],item[1]))

insert_batch(conn,q,data)
```

def generate_doctors(conn):
q="""
insert into doctors
(doctorid,hospitalid,doctorname,phone,room,speciality)
values (%s,%s,%s,%s,%s,%s)
"""

```
specialities=[
    "Cardiologist",
    "Neurologist",
    "Therapist",
    "Pediatrician",
    "Surgeon",
    "Dermatologist",
    "Orthopedist",
    "Otolaryngologist",
    "Endocrinologist",
    "Pulmonologist"
]

for start in range(1,10001,batch_size):
    data=[]
    end=min(start+batch_size,10001)

    for i in range(start,end):
        data.append((
            i,
            random.randint(1,100),
            fake.name(),
            fake.phone_number()[:20],
            random.randint(100,999),
            random.choice(specialities)
        ))

    insert_batch(conn,q,data)
    print(f"doctors: {end-1}")
```

def generate_patients(conn):
q="""
insert into patients
(hospitalid,patientid,patientname,phone)
values (%s,%s,%s,%s)
"""

```
for start in range(1,500001,batch_size):
    data=[]
    end=min(start+batch_size,500001)

    for i in range(start,end):
        data.append((
            random.randint(1,100),
            i,
            fake.name(),
            fake.phone_number()[:20]
        ))

    insert_batch(conn,q,data)
    print(f"patients: {end-1}")
```

def generate_appointments(conn):
q="""
insert into appointments
(appointmentid,patientid,doctorid,diagnosid,appointmentdate)
values (%s,%s,%s,%s,%s)
"""

```
start_date=date(2022,1,1)

for start in range(1,500001,batch_size):
    data=[]
    end=min(start+batch_size,500001)

    for i in range(start,end):
        data.append((
            i,
            random.randint(1,500000),
            random.randint(1,10000),
            random.randint(1,20),
            start_date+timedelta(days=random.randint(0,1460))
        ))

    insert_batch(conn,q,data)
    print(f"appointments: {end-1}")
```

def generate_procedures(conn):
q="""
insert into procedures
(procedureid,appointmentid,room,price)
values (%s,%s,%s,%s)
"""

```
for start in range(1,500001,batch_size):
    data=[]
    end=min(start+batch_size,500001)

    for i in range(start,end):
        data.append((
            i,
            i,
            random.randint(100,999),
            random.randint(5,10000)
        ))

    insert_batch(conn,q,data)
    print(f"procedures: {end-1}")
```

def generate_pharmacy(conn):
q="""
insert into pharmacy
(medicineid,hospitalid,medicinename,medicineallowed,price,quantity)
values (%s,%s,%s,%s,%s,%s)
"""

```
medicines=[
    "Paracetamol",
    "Ibuprofen",
    "Aspirin",
    "Amoxicillin",
    "Vitamin C",
    "Metformin",
    "Omeprazole",
    "Cetirizine",
    "Insulin",
    "Diclofenac"
]

for start in range(1,100001,batch_size):
    data=[]
    end=min(start+batch_size,100001)

    for i in range(start,end):
        data.append((
            i,
            random.randint(1,100),
            random.choice(medicines),
            random.choice(["A","F"]),
            random.randint(10,5000),
            random.randint(0,1000)
        ))

    insert_batch(conn,q,data)
    print(f"pharmacy: {end-1}")
```

def generate_admin(conn):
q="""
insert into admin
(itemid,hospitalid,itemname,price,quantity)
values (%s,%s,%s,%s,%s)
"""

```
items=[
    "Chair",
    "Table",
    "Computer",
    "Printer",
    "Bed",
    "Lamp",
    "Monitor",
    "Wheelchair",
    "Cabinet",
    "Defibrillator",
    "Oxygen Tank",
    "Stretcher"
]

for start in range(1,100001,batch_size):
    data=[]
    end=min(start+batch_size,100001)

    for i in range(start,end):
        data.append((
            i,
            random.randint(1,100),
            random.choice(items),
            random.randint(50,5000),
            random.randint(1,100)
        ))

    insert_batch(conn,q,data)
    print(f"admin: {end-1}")
```

if **name**=="**main**":
conn=create_connection()

```
generate_hospitals(conn)
generate_locations(conn)
generate_finance(conn)
generate_diagnosis(conn)
generate_doctors(conn)
generate_patients(conn)
generate_appointments(conn)
generate_procedures(conn)
generate_pharmacy(conn)
generate_admin(conn)

conn.close()

print("done")

