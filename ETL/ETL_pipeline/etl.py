import psycopg2

def first_transfer(table_list , cur1 , cur2) :
    for i in table_list:
        cur1.execute(select_query + str(i[0]))
        rows = cur1.fetchall()
        for r in rows:
            cur2.execute(insert_query + str(i[0]) + " VALUES" + r)

def count_of_records(table_list,cur1,cur2) :
    destination_database_countofrecords = 0
    for i in table_list:
        cur2.execute("SELECT COUNT(*) FROM " + str(i[0]))
        x=cur2.fetchall()
        destination_database_countofrecords = destination_database_countofrecords + int(str(x[0]))
        return destination_database_countofrecords

def find_pk( tablename, cur1) :
        cur1.execute(primarykey_query1 + "pg_class.oid =" + tablename + primarykey_query2)
        pk = cur1.fetchall()
        return pk


# Connect to source postgres DB
conn1 = psycopg2.connect(
    host = "192.168.1.6",
    database = "library",
    user = "postgres",
    password = "1379",
    port = "5432",)
cur1 = conn1.cursor()
# Connect to destination postgre DB
conn2 = psycopg2.connect(host="192.168.1.6",
                         database="destination_library",
                         user="postgres",
                         password="1379",
                         port="5432", )
cur2 = conn2.cursor()

catalog_query1 = """SELECT table_name
                   FROM information_schema.tables
                   WHERE table_schema='public'
                   AND table_type='BASE TABLE';"""
select_query = "SELECT * FROM "
insert_query = "INSERT INTO "
primarykey_query1 = """SELECT               
pg_attribute.attname, 
format_type(pg_attribute.atttypid, pg_attribute.atttypmod) 
FROM pg_index, pg_class, pg_attribute, pg_namespace 
WHERE """
primarykey_query2 = """::regclass AND 
indrelid = pg_class.oid AND 
nspname = 'public' AND 
pg_class.relnamespace = pg_namespace.oid AND 
pg_attribute.attrelid = pg_class.oid AND 
pg_attribute.attnum = any(pg_index.indkey)
AND indisprimary"""
cur1.execute(catalog_query1)
table_list = cur1.fetchall()

if count_of_records(table_list,cur1,cur2) == 0 :
    first_transfer(table_list,cur1,cur2)
    conn2.commit()
    cur2.close()
    conn2.close()
    conn1.commit()
    cur1.close()
    conn1.close()
else:
    # Find deleted record from source database
    for j in table_list:
        cur1.execute(select_query+str(j[0])+" OEDER BY "+find_pk(str(j[0]),cur1)+" ASC")
        source_result = cur1.fetchall()

        cur2.execute(select_query+str(j[0])+" OEDER BY "+find_pk(str(j[0]),cur2)+" ASC")
        destination_result = cur2.fetchall()
        if source_result != destination_result :
                cur2.execute(insert_query+str(j[0])+" VALUES"+source_result)



    conn2.commit()
    cur2.close()
    conn2.close()
    conn1.commit()
    cur1.close()
    conn1.close()

