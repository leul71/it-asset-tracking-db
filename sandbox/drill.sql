DROP SCHEMA IF EXISTS drill CASCADE;

CREATE SCHEMA drill;

CREATE TABLE drill.vendors (
    vendor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_name TEXT NOT NULL UNIQUE,
    vendor_phone TEXT NOT NULL
);
INSERT INTO drill.vendors (vendor_name, vendor_phone)
VALUES( 'vendor1',  '800-555-0101'),
       ('vendor2', '800-555-0103'),
       ('vendor3', '800-555-0102');



 CREATE TABLE drill.assets (
    asset_name TEXT NOT NULL,
    asset_type TEXT NOT NULL,
    asset_tag TEXT PRIMARY KEY,
    vendor_id INTEGER NOT NULL REFERENCES drill.vendors(vendor_id)
 );

 INSERT INTO drill.assets (asset_name, asset_type, asset_tag, vendor_id)
 VALUES ('asset1', 'Laptop', 'AT-0001', 1),
       ('asset2', 'Printer', 'AT-0002', 2),
       ('asset3', 'Laptop', 'AT-0003', 3),
       ('asset4', 'Printer', 'AT-0004', 1);



SELECT *
FROM drill.assets
JOIN drill.vendors ON drill.assets.vendor_id = drill.vendors.vendor_id;
