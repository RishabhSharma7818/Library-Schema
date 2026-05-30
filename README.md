# Library Management System — MySQL Database Schema

A relational database schema for managing a library's core operations including book cataloguing, member management, borrowing records, and fine tracking.

---

## Database Schema

The schema consists of 7 tables:

| Table | Description |
|---|---|
| `categories` | Book genres such as Fiction, Science, History |
| `authors` | Author details including name and nationality |
| `books` | Book catalogue with ISBN, publisher, and copy count |
| `book_authors` | Links books to their authors (many-to-many) |
| `members` | Registered library members with membership type |
| `borrowings` | Borrow and return records with due date tracking |
| `fines` | Overdue fines linked to specific borrowings |

---

## Relationships

- A **category** can have many **books**
- A **book** can have many **authors**, and an **author** can write many **books** (via `book_authors`)
- A **member** can have many **borrowings**
- A **book** can be borrowed many times
- Each **borrowing** can generate one **fine**

---

## Key Design Highlights

- **Normalization (3NF)** — no redundant or repeated data across tables
- **Composite Primary Key** — `book_authors(book_id, author_id)` handles many-to-many without duplication
- **Surrogate Keys** — `AUTO_INCREMENT` integer IDs on all main tables
- **Constraints** — `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`, `DEFAULT`, `ENUM` used throughout
- **Referential Integrity** — all foreign keys reference valid parent rows

---

## How to Run

1. Open MySQL Workbench (or any MySQL client)
2. Run the script:

```bash
mysql -u root -p < library_schema.sql
```

Or open `library_schema.sql` in MySQL Workbench and press **Ctrl+Shift+Enter** to execute.

---

## Sample Data Included

The script inserts sample records for:
- 4 categories, 4 authors, 4 books
- 3 members (student, faculty, general)
- 3 borrowing records (returned, active, overdue)
- 1 unpaid fine
