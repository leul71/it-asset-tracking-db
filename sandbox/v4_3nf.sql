DROP SCHEMA IF EXISTS v4 CASCADE;

CREATE SCHEMA v4;

CREATE TABLE v4.vendors (
    vendor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_name TEXT NOT NULL UNIQUE,
    vendor_phone TEXT NOT NULL
);

INSERT INTO v4.vendors (vendor_name, vendor_phone)
VALUES ('Dell',  '800-555-0101'),
       ('Apple', '800-555-0103'),
       ('HP',    '800-555-0102'),
       ('Canon', '800-555-0104'),
       ('Epson', '800-555-0105');

CREATE TABLE v4.categories (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE
) ;
INSERT INTO v4.categories (category_name)
VALUES ('Laptop'),
       ('Printer'),
       ('Monitor'),
       ('Phone');

CREATE TABLE v4.locations (
    location_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    building TEXT NOT NULL,
    floor INT,
    UNIQUE (building, floor)
);
INSERT INTO v4.locations (building, floor)
VALUES ('Main Building', 1),
       ('Main Building', 2),
       ('Annex Building', 1),
       ('Annex Building', 2);
       

--SELECT * from v4.vendors;
--INSERT INTO v4.locations (building, floor) VALUES ('Main Building', 1);

CREATE TABLE v4.departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE,
    manager_id INTEGER
);

CREATE TABLE v4.employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_name TEXT NOT NULL,
    department_id INTEGER NOT NULL REFERENCES v4.departments(department_id)
);

ALTER TABLE v4.departments
ADD CONSTRAINT fk_manager 
FOREIGN KEY (manager_id) REFERENCES v4.employees(employee_id);

INSERT INTO v4.departments (department_name)
VALUES ('HR'),
       ('Finance'),
       ('IT'),
       ('Marketing');

INSERT INTO v4.employees (employee_name, department_id)
VALUES ('John Doe', 1),
       ('Jane Smith', 2),
       ('Alice Johnson', 3),
       ('Bob Brown', 4),
       ('Charlie Davis', 1),
       ('Diana Evans', 2),
       ('Ethan Foster', 3),
       ('Fiona Green', 4);

UPDATE v4.departments
SET manager_id = 1
WHERE department_name = 'HR';
UPDATE v4.departments
SET manager_id = 2
WHERE department_name = 'Finance';
UPDATE v4.departments
SET manager_id = 3
WHERE department_name = 'IT';
UPDATE v4.departments
SET manager_id = 4
WHERE department_name = 'Marketing';

SELECT department_name, manager_id, employee_name AS manager_name
FROM v4.departments 
LEFT JOIN v4.employees 
ON v4.departments.manager_id = v4.employees.employee_id;

UPDATE v4.departments SET manager_id = 7 WHERE department_name = 'Finance';

CREATE TABLE v4.assets (
    asset_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asset_tag TEXT NOT NULL UNIQUE,
    category_id INTEGER NOT NULL REFERENCES v4.categories(category_id),
    vendor_id INTEGER NOT NULL REFERENCES v4.vendors(vendor_id),
    location_id INTEGER NOT NULL REFERENCES v4.locations(location_id),
    employee_id INTEGER REFERENCES v4.employees(employee_id)
);
INSERT INTO v4.assets (asset_tag, category_id, vendor_id, location_id, employee_id)
VALUES ('LAP001', 1, 1, 1, 1),
       ('PRN001', 2, 2, 2, 2),
       ('MON001', 3, 3, 3, 3),
       ('PHN001', 4, 4, 4, 4),
       ('LAP002', 1, 1, 1, 5),
       ('PRN002', 2, 2, 2, 6),
       ('MON002', 3, 3, 3, 7),
       ('PHN002', 4, 4, 4, 8);

SELECT a.asset_tag, c.category_name, v.vendor_name,
       l.building, l.floor,
       e.employee_name AS assigned_to,
       d.department_name,
       m.employee_name AS dept_manager
FROM v4.assets a
JOIN      v4.categories  c ON a.category_id = c.category_id
JOIN      v4.vendors     v ON a.vendor_id = v.vendor_id
LEFT JOIN v4.locations   l ON a.location_id = l.location_id
LEFT JOIN v4.employees   e ON a.employee_id = e.employee_id
LEFT JOIN v4.departments d ON e.department_id = d.department_id
LEFT JOIN v4.employees   m ON d.manager_id = m.employee_id
ORDER BY a.asset_tag;