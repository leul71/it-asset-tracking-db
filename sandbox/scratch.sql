-- scratch.sql | Block B | normalization sandbox

Drop SCHEMA IF EXISTS v1, v2, v3 CASCADE;
CREATE SCHEMA v1;
CREATE SCHEMA v2;
CREATE SCHEMA v3;

CREATE TABLE v1.assets_flat (
    asset_tag TEXT PRIMARY KEY,
    asset_type TEXT NOT NULL,
    vendor_name TEXT,
    vendor_phone TEXT,
    assigned_to TEXT,
    employee_dept TEXT,
    dept_manager TEXT
);

Insert INTO v1.assets_flat VALUES
('LT-0001', 'Laptop', 'Dell', '800-555-0101', 'Maya Chen', 'Finance', 'R. Ortiz'),
('LT-0002', 'Laptop', 'Dell', '800-555-0101', 'Sam Patel', 'IT', 'K. Wright'),
('LT-0003', 'Laptop', 'Dell', '800-555-0106', 'Jane Doe', 'HR', 'S. Patel'),
('LT-0004', 'Laptop', 'Apple', '800-555-0103', 'Mike Brown', 'IT', 'L. Johnson'),
('PR-0001', 'Printer', 'HP', '800-555-0102', NULL, NULL, NULL),
('PR-0002', 'Printer', 'Canon', '800-555-0104', NULL, NULL, NULL),
('PR-0003', 'Printer', 'Epson', '800-555-0105', NULL, NULL, NULL),
('PR-0004', 'Printer', 'Dell', '800-555-0101', NULL, NULL, NULL),
('LT-0005', 'Laptop', 'Apple', '800-555-0103', 'Alice Smith', 'Marketing', 'J. Lee'),
('pr-0005', 'Printer', 'Brother', '800-555-0107', NULL, NULL, NULL),
('LT-0006', 'Laptop', 'Lenovo', '800-555-0108', 'Bob Johnson', 'Sales', 'M. Davis');


CREATE TABLE v2.vendors (
    vendor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_name TEXT NOT NULL UNIQUE,
    vendor_phone TEXT NOT NULL
);

INSERT INTO v2.vendors (vendor_name, vendor_phone)
VALUES ('Dell',  '800-555-0101'),
       ('Apple', '800-555-0103'),
       ('HP',    '800-555-0102'),
       ('Canon', '800-555-0104'),
       ('Epson', '800-555-0105');

CREATE TABLE v2.departments (
    dept_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name TEXT NOT NULL UNIQUE,
    dept_manager TEXT NOT NULL
);
INSERT INTO v2.departments (dept_name, dept_manager)
VALUES ('Finance', 'R. Ortiz'),
       ('IT', 'K. Wright'),
       ('HR', 'S. Patel'),
       ('Marketing', 'J. Lee'),
       ('Sales', 'M. Davis');

SELECT * FROM v2.departments;

CREATE TABLE v2.assets (
    asset_tag TEXT PRIMARY KEY,
    asset_type TEXT NOT NULL,
    vendor_id INTEGER NOT NULL REFERENCES v2.vendors(vendor_id),
    assigned_to TEXT,
    dept_id INTEGER REFERENCES v2.departments(dept_id)
);

INSERT INTO v2.assets (asset_tag, asset_type, vendor_id, assigned_to, dept_id)
VALUES ('LT-0001', 'Laptop', 1, 'Maya Chen', 1),
       ('LT-0002', 'Laptop', 1, 'Sam Patel', 2),
       ('LT-0003', 'Laptop', 1, 'Jane Doe', 3),
       ('LT-0004', 'Laptop', 2, 'Mike Brown', 2),
       ('PR-0001', 'Printer', 3, NULL, NULL),
       ('PR-0002', 'Printer', 4, NULL, NULL),
       ('PR-0003', 'Printer', 5, NULL, NULL),
       ('PR-0004', 'Printer', 1, NULL, NULL),
       ('LT-0005', 'Laptop', 2, 'Alice Smith', 4),
       ('pr-0005', 'Printer', 1, NULL, NULL),
       ('LT-0006', 'Laptop', 5, 'Bob Johnson', 5);


CREATE TABLE v3.departments (
    dept_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name TEXT NOT NULL UNIQUE,
    dept_manager TEXT NOT NULL
);
INSERT INTO v3.departments (dept_name, dept_manager)
VALUES ('Finance', 'R. Ortiz'),
       ('IT', 'K. Wright'),
       ('HR', 'S. Patel'),
       ('Marketing', 'J. Lee'),
       ('Sales', 'M. Davis');


CREATE TABLE v3.vendors (
    vendor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_name TEXT NOT NULL UNIQUE,
    vendor_phone TEXT NOT NULL
);

INSERT INTO v3.vendors (vendor_name, vendor_phone)
VALUES ('Dell',  '800-555-0101'),
       ('Apple', '800-555-0103'),
       ('HP',    '800-555-0102'),
       ('Canon', '800-555-0104'),
       ('Epson', '800-555-0105');

CREATE TABLE v3.employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_name TEXT NOT NULL UNIQUE,
    dept_id INTEGER NOT NULL REFERENCES v3.departments(dept_id)
);

INSERT INTO v3.employees (employee_name, dept_id)
VALUES ('Maya Chen', 1),
       ('Sam Patel', 2),
       ('Jane Doe', 3),
       ('Mike Brown', 2),
       ('Alice Smith', 4),
       ('Bob Johnson', 5);
;

CREATE TABLE v3.assets (
    asset_tag TEXT PRIMARY KEY,
    asset_type TEXT NOT NULL,
    vendor_id INTEGER NOT NULL REFERENCES v3.vendors(vendor_id),
    employee_id INTEGER REFERENCES v3.employees(employee_id)
);

INSERT INTO v3.assets (asset_tag, asset_type, vendor_id, employee_id)
VALUES ('LT-0001', 'Laptop', 1, 1),
       ('LT-0002', 'Laptop', 1, 2),
       ('LT-0003', 'Laptop', 1, 3),
       ('LT-0004', 'Laptop', 2, 4),
       ('PR-0001', 'Printer', 3, NULL),
       ('PR-0002', 'Printer', 4, NULL),
       ('PR-0003', 'Printer', 5, NULL),
       ('PR-0004', 'Printer', 1, NULL),
       ('LT-0005', 'Laptop', 2, 5),
       ('PR-0005', 'Printer', 1, NULL),
       ('LT-0006', 'Laptop', 5, 6);

SELECT a.asset_tag, a.asset_type, v.vendor_name,
       e.employee_name, d.dept_name, d.dept_manager
FROM v3.assets a
JOIN v3.vendors v          ON a.vendor_id = v.vendor_id
LEFT JOIN v3.employees e   ON a.employee_id = e.employee_id
LEFT JOIN v3.departments d ON e.dept_id = d.dept_id
ORDER BY a.asset_tag;