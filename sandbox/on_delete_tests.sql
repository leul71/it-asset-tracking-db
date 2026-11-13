DROP SCHEMA IF EXISTS del_test CASCADE;
CREATE SCHEMA del_test;

CREATE TABLE del_test.departments (
    department_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE
);

CREATE TABLE del_test.employees (
    employee_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_name TEXT NOT NULL,
    department_id INTEGER REFERENCES del_test.departments(department_id)
                  ON DELETE CASCADE
);

INSERT INTO del_test.departments (department_name) VALUES ('IT'), ('HR');
INSERT INTO del_test.employees (employee_name, department_id)
VALUES ('Alice', 1), ('Bob', 1), ('Carol', 2), ('Dan', 2);

DELETE FROM del_test.departments WHERE department_name = 'IT';

SELECT * FROM del_test.departments;
SELECT * FROM del_test.employees;