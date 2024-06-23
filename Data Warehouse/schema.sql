CREATE DATABASE library_data_warehouse;

CREATE TYPE yesorno AS ENUM ('yes','no');

CREATE TABLE Book1A
(book_id SERIAL NOT NULL,
isbn INTEGER NOT NULL CHECK(isbn BETWEEN 0 AND 9999999999999),
m_number INTEGER CHECK(m_number BETWEEN 0 AND 9999999999),
delivery_date DATE,
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (book_id));

CREATE TABLE Book1B
(isbn INTEGER NOT NULL CHECK(isbn BETWEEN 0 AND 9999999999999),
version_number INTEGER,
title VARCHAR(50),
description VARCHAR(500),
publication_date DATE,
publisher_name VARCHAR(100),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (isbn));

ALTER TABLE Book1A
ADD FOREIGN KEY (isbn) REFERENCES Book1B (isbn)
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2A
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
translator_fname VARCHAR(15),
translator_lname VARCHAR(15),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2B
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
writer_fname VARCHAR(15),
writer_lname VARCHAR(15),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2C
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
language VARCHAR(15),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2D
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
genre VARCHAR(15),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Member
(membership_number INTEGER NOT NULL CHECK(membership_number BETWEEN 0 AND 9999999999),
membership_date DATE,
birth_date DATE,
fname VARCHAR(15),
lname VARCHAR(15),
address VARCHAR(100),
phone_number INTEGER CHECK(phone_number BETWEEN 0 AND 99999999999),
datetime_of_insert timestamp NOT NULL,
is_modified yesorno NOT NULL DEFAULT 'no',
PRIMARY KEY (membership_number));

ALTER TABLE Book1A
ADD FOREIGN KEY (m_number) REFERENCES Member(membership_number)
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TYPE reason AS ENUM ('UPDATE','DELETE');

CREATE TABLE Book1A_History
(book_id SERIAL NOT NULL,
isbn INTEGER NOT NULL CHECK(isbn BETWEEN 0 AND 9999999999999),
m_number INTEGER CHECK(m_number BETWEEN 0 AND 9999999999),
delivery_date DATE,
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
book_id_id SERIAL NOT NULL,
isbn_id INTEGER,
m_number_id INTEGER,
PRIMARY KEY (book_id,book_id_id));

CREATE TABLE Book1B_History
(isbn INTEGER NOT NULL CHECK(isbn BETWEEN 0 AND 9999999999999),
version_number INTEGER,
title VARCHAR(50),
description VARCHAR(500),
publication_date DATE,
publisher_name VARCHAR(100),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
isbn_id SERIAL NOT NULL,
PRIMARY KEY (isbn,isbn_id));

ALTER TABLE Book1A_History
ADD FOREIGN KEY (isbn) REFERENCES Book1B_History (isbn)
		ON DELETE SET NULL	ON UPDATE CASCADE
ADD FOREIGN KEY (isbn_id) REFERENCES Book1B_History (isbn_id)
		ON DELETE SET NULL	ON UPDATE CASCADE;


CREATE TABLE Book2A_History
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
translator_fname VARCHAR(15),
translator_lname VARCHAR(15),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
book_id_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A_History (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE
FOREIGN KEY (book_id_id) REFERENCES Book1A_History (book_id_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2B_History
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
writer_fname VARCHAR(15),
writer_lname VARCHAR(15),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
book_id_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A_History (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE
FOREIGN KEY (book_id_id) REFERENCES Book1A_History (book_id_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2C_History
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
language VARCHAR(15),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
book_id_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A_History (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE
FOREIGN KEY (book_id_id) REFERENCES Book1A_History (book_id_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Book2D_History
(book_id INTEGER NOT NULL,
id SERIAL NOT NULL,
genre VARCHAR(15),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
book_id_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (book_id) REFERENCES Book1A_History (book_id))
		ON DELETE SET NULL	ON UPDATE CASCADE
FOREIGN KEY (book_id_id) REFERENCES Book1A_History (book_id_id))
		ON DELETE SET NULL	ON UPDATE CASCADE;

CREATE TABLE Member_History
(membership_number INTEGER NOT NULL CHECK(membership_number BETWEEN 0 AND 9999999999),
membership_date DATE,
birth_date DATE,
fname VARCHAR(15),
lname VARCHAR(15),
address VARCHAR(100),
phone_number INTEGER CHECK(phone_number BETWEEN 0 AND 99999999999),
datetime_of_exit timestamp NOT NULL,
reason_for_exit reason NOT NULL,
membership_number_id SERIAL NOT NULL,
PRIMARY KEY (membership_number,membership_number_id));

ALTER TABLE Book1A_History
ADD FOREIGN KEY (m_number) REFERENCES Member_History (membership_number)
		ON DELETE SET NULL	ON UPDATE CASCADE
ADD FOREIGN KEY (m_number_id) REFERENCES Member_History (membership_number_id)
		ON DELETE SET NULL	ON UPDATE CASCADE;



