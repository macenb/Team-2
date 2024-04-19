-- set up user roles and passwords
ALTER USER postgres WITH NOSUPERUSER;
ALTER ROLE postgres WITH PASSWORD 'S3cr3tDBP@ss!';
REVOKE ALL ON DATABASE db FROM postgres;
GRANT CONNECT ON DATABASE db TO postgres;
REVOKE ALL ON purchases FROM postgres;
GRANT SELECT ON purchases TO postgres;
GRANT INSERT ON purchases TO postgres;
GRANT UPDATE ON purchases TO postgres;
GRANT DELETE ON purchases TO postgres;
REVOKE ALL ON purchases FROM postgres;
GRANT SELECT ON receipts TO postgres;
GRANT INSERT ON receipts TO postgres;
GRANT UPDATE ON receipts TO postgres;
GRANT DELETE ON receipts TO postgres;

-- DATABASE SETUP
-- DROP TABLES
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS receipts CASCADE;
DROP TABLE IF EXISTS purchases CASCADE;
-- Create users table
        
CREATE TABLE IF NOT EXISTS users ( 
    username VARCHAR(32) PRIMARY KEY,
    password VARCHAR(32) NOT NULL,
    admin BOOLEAN NOT NULL DEFAULT FALSE
);

-- Create session, table

CREATE TABLE IF NOT EXISTS sessions (
    session_id CHAR(32) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    expiration TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES users (username)
);

-- Create items table

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    description VARCHAR(255),
    image VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL
);

-- Create recipts table

CREATE TABLE IF NOT EXISTS receipts (
    id SERIAL PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    date TIMESTAMP NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (username) REFERENCES users (username)
);

-- Create purchases table
CREATE TABLE IF NOT EXISTS purchases (
    receipt_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items (id),
    FOREIGN KEY (receipt_id) REFERENCES receipts (id)
);
,
-- create admin user

INSERT INTO users (username, password, admin) VALUES ('admin', 'admin', TRUE);

-- create items
INSERT INTO items (name, description, image, price) VALUES
    ('Electric Guitar', 'A standard electric guitar suitable for beginners and intermedlate placers.', '/electric-guitar.png', 120.00),
    ('Headphones', 'Over-ear headphones with excellent sound quality and noise isolation.', '/headphones.png', 70.00),
    ('Microphone', 'A versatile microphone ideal for recording vocals and instruments in studio settings.', '/microphone.png', 50.00),
    ('Music Stand', 'A durable and adjustable music stand, suitable for holding sheet music at a comfortable reading angle.', '/music-stand.png', 25.00),
    ('Keyboard', 'A 61-key electronic keyboard perfect for beginners learning to play.', '/keyboard.png', 100.00),
    ('Guitar Strings', 'High-quality acoustic guitar strings known for their bright tone and long-lasting durability.', '/guitar-strings.png', 10.00),
    ('Drumsticks', 'A pair of wooden drumsticks, balanced for speed and control.', '/drumsticks.png', 8.00),
    ('Tuner', 'A clip-on guitar tuner with an easy-to-read display, suitable for guitars and other stringed instruments.', '/tuner.png', 15.00),
    ('Music Book', 'A beginners book for learning music theory and notation.', '/music-book.png', 20.00),
    ('Speaker', 'Portable Bluetooth speaker with high-quality sound and robust battery life.', '/speaker.png', 45.00),
    ('Vinyl Record', 'Classic vinyl record featuring popular hits from the 70s and 80s.', 'vinyl-record.png', 30.00),
    ('Guitar Capo', 'A lightweight and easy-to-use capo for acoustic and electric guitars.', '/guitar-capo.png'. 12.00),
    ('Metronome', 'A digital metronome to help musicians keep a steady tempo during practice.', '/metronome.png', 22.00),
    ('Guitar Picks', 'A set of 10 assorted guitar picks in various thicknesses.', '/guitar-picks.png', 5.00),
    ('Ukulele', 'A fun and easy-to-play soprano ukulele, great for beginners and hobbyists.', '/ukulele.png', 40.00);

-- Create receipts

INSERT INTO receipts (username, date, total) VALUES
    ('admin', '2020-01-01 12:00:00', 100.00),
    ('admin', '2020-01-02 12:00:00', 150.00),
    ('admin', '2020-01-03 12:00:00', 200.00),
    ('admin', '2020-01-04 12:00:00', 250.00),
    ('admin', '2020-01-05 12:00:00', 300.00);

-- Create purchases

INSERT INTO purchases (receipt_id, item_id, quantity) VALUES
    (1, 1, 1),
    (1, 2, 2),
    (1, 3, 3),
    (1, 4, 4),
    (2, 5, 1),
    (2, 6, 2), 
    (2, 7, 3),
    (2, 8, 4),
    (3, 9, 1),
    (3, 10, 2),
    (3, 11, 3),
    (3, 12, 4),
    (4, 13, 1),
    (4, 14, 2),
    (4, 15, 3),
    (4, 1, 4),
    (5, 2, 1),
    (5, 3, 2),
    (5, 4, 3),
    (5, 5, 4);
