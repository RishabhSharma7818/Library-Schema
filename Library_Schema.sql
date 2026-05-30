-- Library Management System - Schema Design
-- Domain: Library
-- Database Setup and Schema Design
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Table: CATEGORIES
-- Stores book genres/categories
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT
);

-- Table: AUTHORS
-- Stores author information
CREATE TABLE authors (
    author_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    nationality VARCHAR(100)
);

-- Table: BOOKS
-- Stores book details
CREATE TABLE books (
    book_id          INT AUTO_INCREMENT PRIMARY KEY,
    category_id      INT NOT NULL,
    title            VARCHAR(255) NOT NULL,
    isbn             VARCHAR(20) NOT NULL UNIQUE,
    publisher        VARCHAR(150),
    publish_year     YEAR,
    total_copies     INT NOT NULL DEFAULT 1 CHECK (total_copies >= 1),
    available_copies INT NOT NULL DEFAULT 1 CHECK (available_copies >= 0),
    CONSTRAINT fk_books_category FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

-- Table: BOOK_AUTHORS (Junction)
-- Many-to-many: Books <-> Authors
-- Uses composite primary key
CREATE TABLE book_authors (
    book_id   INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),  -- Composite key
    CONSTRAINT fk_ba_book   FOREIGN KEY (book_id)   REFERENCES books   (book_id),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors  (author_id)
);

-- Table: MEMBERS
-- Stores library member details
CREATE TABLE members (
    member_id       INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_type ENUM('student', 'faculty', 'general') NOT NULL DEFAULT 'general'
);

-- Table: BORROWINGS
-- Tracks book borrow/return records
CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id    INT NOT NULL,
    book_id      INT NOT NULL,
    borrow_date  DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date     DATE NOT NULL,
    return_date  DATE,
    status       ENUM('borrowed', 'returned', 'overdue') NOT NULL DEFAULT 'borrowed',
    CONSTRAINT fk_borrow_member FOREIGN KEY (member_id) REFERENCES members (member_id),
    CONSTRAINT fk_borrow_book   FOREIGN KEY (book_id)   REFERENCES books    (book_id),
    CONSTRAINT chk_due_date CHECK (due_date > borrow_date)
);

-- Table: FINES
-- Tracks overdue fines per borrowing
CREATE TABLE fines (
    fine_id      INT AUTO_INCREMENT PRIMARY KEY,
    member_id    INT NOT NULL,
    borrowing_id INT NOT NULL UNIQUE,
    amount       DECIMAL(8, 2) NOT NULL CHECK (amount > 0),
    status       ENUM('unpaid', 'paid') NOT NULL DEFAULT 'unpaid',
    issued_date  DATE NOT NULL DEFAULT (CURRENT_DATE),
    paid_date    DATE,
    CONSTRAINT fk_fine_member    FOREIGN KEY (member_id)    REFERENCES members    (member_id),
    CONSTRAINT fk_fine_borrowing FOREIGN KEY (borrowing_id) REFERENCES borrowings (borrowing_id)
);

-- Sample Data
INSERT INTO categories (category_name, description) VALUES
('Fiction',        'Novels and short stories'),
('Science',        'Natural and applied sciences'),
('History',        'Historical accounts and biographies'),
('Technology',     'Computing, engineering, and IT');

INSERT INTO authors (first_name, last_name, nationality) VALUES
('George',  'Orwell',   'British'),
('J.K.',    'Rowling',  'British'),
('Stephen', 'Hawking',  'British'),
('Cal',     'Newport',  'American');

INSERT INTO books (category_id, title, isbn, publisher, publish_year, total_copies, available_copies) VALUES
(1, '1984',                       '978-0451524935', 'Secker & Warburg',    1949, 5, 5),
(1, 'Harry Potter and the Sorcerer''s Stone', '978-0439708180', 'Scholastic', 1997, 4, 4),
(2, 'A Brief History of Time',    '978-0553380163', 'Bantam Books',        1988, 3, 3),
(4, 'Deep Work',                  '978-1455586691', 'Grand Central',       2016, 3, 3);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- 1984 → Orwell
(2, 2), -- Harry Potter → Rowling
(3, 3), -- Brief History → Hawking
(4, 4); -- Deep Work → Newport

INSERT INTO members (name, email, phone, membership_type) VALUES
('Aarav Sharma',  'aarav@example.com',  '9876543210', 'student'),
('Priya Mehta',   'priya@example.com',  '9123456780', 'faculty'),
('Rohit Verma',   'rohit@example.com',  '9001234567', 'general');

INSERT INTO borrowings (member_id, book_id, borrow_date, due_date, status) VALUES
(1, 1, '2026-05-01', '2026-05-15', 'returned'),
(2, 3, '2026-05-20', '2026-06-10', 'borrowed'),
(3, 2, '2026-04-10', '2026-04-24', 'overdue');

-- Fine for overdue borrowing
INSERT INTO fines (member_id, borrowing_id, amount, status, issued_date) VALUES
(3, 3, 36.00, 'unpaid', '2026-04-25');

