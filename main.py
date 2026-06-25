#код для генерування таблиць створений ШІ
import random
from datetime import date, timedelta

import psycopg2
from psycopg2.extras import execute_batch
from faker import Faker

fake = Faker()

host = "localhost"
port = "5432"
database = "Ass4"
user = "postgres"
password = "54321"

batch_size = 10000


def create_connection():
    return psycopg2.connect(
        host=host,
        port=port,
        dbname=database,
        user=user,
        password=password
    )


def insert_batch(connection, query, data):
    with connection.cursor() as cursor:
        execute_batch(cursor, query, data, page_size=1000)
    connection.commit()


def generate_hospitals(connection):
    query = """
    insert into hospitals
    (hospitalid, maxquantity, rating)
    values (%s, %s, %s)
    on conflict do nothing
    """
    data = []
    for hospital_id in range(1, 101):
        data.append((
            hospital_id,
            random.randint(100, 3000),
            round(random.uniform(1, 5), 2)
        ))
    insert_batch(connection, query, data)


def generate_locations(connection):
    query = """
    insert into locations
    (hospitalid, city, address)
    values (%s, %s, %s)
    on conflict do nothing
    """
    data = []
    for hospital_id in range(1, 101):
        data.append((
            hospital_id,
            fake.city(),
            fake.street_address()
        ))
    insert_batch(connection, query, data)


def generate_finance(connection):
    query = """
    insert into finance
    (hospitalid, income, avgincome)
    values (%s, %s, %s)
    on conflict do nothing
    """
    data = []
    for hospital_id in range(1, 101):
        income = random.randint(500000, 10000000)
        data.append((
            hospital_id,
            income,
            income // 12
        ))
    insert_batch(connection, query, data)


def generate_diagnosis(connection):
    diagnoses = [
        ("flu", "influenza"),
        ("covid", "coronavirus"),
        ("diabetes", "sugar disease"),
        ("asthma", "breathing disorder"),
        ("fracture", "bone injury"),
        ("migraine", "head pain"),
        ("hypertension", "high blood pressure"),
        ("allergy", "immune reaction")
    ]

    query = """
    insert into diagnosis
    (diagnosid, diagnos, description)
    values (%s, %s, %s)
    on conflict do nothing
    """

    data = []

    for i, item in enumerate(diagnoses, start=1):
        data.append((i, item[0], item[1]))

    insert_batch(connection, query, data)


def generate_doctors(connection):
    query = """
    insert into doctors
    (doctorid, hospitalid, doctorname, phone, room, speciality)
    values (%s, %s, %s, %s, %s, %s)
    on conflict do nothing
    """

    specialities = [
        "cardiologist",
        "dentist",
        "neurologist",
        "surgeon",
        "therapist",
        "pediatrician"
    ]

    total = 10000

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for doctor_id in range(start, end):
            data.append((
                doctor_id,
                random.randint(1, 100),
                fake.name(),
                fake.phone_number()[:20],
                random.randint(100, 999),
                random.choice(specialities)
            ))

        insert_batch(connection, query, data)
        print(f"doctors: {end - 1}/{total}")


def generate_patients(connection):
    query = """
    insert into patients
    (hospitalid, patientid, patientname, phone)
    values (%s, %s, %s, %s)
    on conflict do nothing
    """

    total = 500000

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for patient_id in range(start, end):
            data.append((
                random.randint(1, 100),
                patient_id,
                fake.name(),
                fake.phone_number()[:20]
            ))

        insert_batch(connection, query, data)
        print(f"patients: {end - 1}/{total}")


def generate_appointments(connection):
    query = """
    insert into appointments
    (appointmentid, patientid, doctorid, diagnosid, appointmentdate)
    values (%s, %s, %s, %s, %s)
    on conflict do nothing
    """

    total = 500000
    start_date = date(2022, 1, 1)

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for appointment_id in range(start, end):
            data.append((
                appointment_id,
                random.randint(1, 500000),
                random.randint(1, 10000),
                random.randint(1, 8),
                start_date + timedelta(days=random.randint(0, 1460))
            ))

        insert_batch(connection, query, data)
        print(f"appointments: {end - 1}/{total}")


def generate_procedures(connection):
    query = """
    insert into procedures
    (procedureid, description, appointmentid, room, price)
    values (%s, %s, %s, %s, %s)
    on conflict do nothing
    """

    total = 500000

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for procedure_id in range(start, end):
            data.append((
                procedure_id,
                fake.sentence(nb_words=4),
                procedure_id,
                random.randint(100, 999),
                random.randint(100, 10000)
            ))

        insert_batch(connection, query, data)
        print(f"procedures: {end - 1}/{total}")


def generate_pharmacy(connection):
    query = """
    insert into pharmacy
    (medicineid, hospitalid, medicinename, medicineallowed, price, quantity)
    values (%s, %s, %s, %s, %s, %s)
    on conflict do nothing
    """

    medicines = [
        "paracetamol",
        "ibuprofen",
        "aspirin",
        "amoxicillin",
        "vitamin c"
    ]

    total = 100000

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for medicine_id in range(start, end):
            data.append((
                medicine_id,
                random.randint(1, 100),
                random.choice(medicines),
                random.choice([True, False]),
                random.randint(10, 1000),
                random.randint(0, 500)
            ))

        insert_batch(connection, query, data)
        print(f"pharmacy: {end - 1}/{total}")


def generate_admin(connection):
    query = """
    insert into admin
    (itemid, hospitalid, itemname, allowed, price, quantity)
    values (%s, %s, %s, %s, %s, %s)
    on conflict do nothing
    """

    items = [
        "chair",
        "table",
        "computer",
        "printer",
        "bed",
        "lamp"
    ]

    total = 100000

    for start in range(1, total + 1, batch_size):
        data = []
        end = min(start + batch_size, total + 1)

        for item_id in range(start, end):
            data.append((
                item_id,
                random.randint(1, 100),
                random.choice(items),
                random.choice([True, False]),
                random.randint(50, 5000),
                random.randint(1, 100)
            ))

        insert_batch(connection, query, data)
        print(f"admin: {end - 1}/{total}")


if __name__ == "__main__":
    connection = create_connection()

    generate_hospitals(connection)
    generate_locations(connection)
    generate_finance(connection)
    generate_diagnosis(connection)
    generate_doctors(connection)
    generate_patients(connection)
    generate_appointments(connection)
    generate_procedures(connection)
    generate_pharmacy(connection)
    generate_admin(connection)

    connection.close()

    print("done")

