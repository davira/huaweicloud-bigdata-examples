/*
	Data Warehouse (DWS) on Huawei Cloud
	Data encryption sample
	@Author: David, Yufei
	@Date: 20220705

	For more details, please check: 
	https://support.huaweicloud.com/intl/en-us/sqlreference-dws/dws_06_0250.html
*/


-- Secret
SET ROLE dbadmin PASSWORD 'SECRET_PASSWORD';


-- Create new schema
DROP SCHEMA IF EXISTS column_level_schema CASCADE;
CREATE SCHEMA column_level_schema;
SET CURRENT_SCHEMA TO 'column_level_schema';



-- Create sample tables
DROP TABLE IF EXISTS employee_info;
CREATE TABLE employee_info (
  emp_id int NOT NULL,
  name varchar(50),
  surname varchar(50),
  age varchar(50),
  position_level int,
  join_date date,
  salary FLOAT8
);


INSERT INTO employee_info VALUES(1, 'David', 'Sanchez Plaza', 35, 17, '2016-02-26', 2000);
INSERT INTO employee_info VALUES(2, 'Penny', 'Peng', 27, 16, '2015-01-01', 18000);
INSERT INTO employee_info VALUES(3, 'Fei', 'Yu', 32, 16, '2014-01-01', 25000);
INSERT INTO employee_info VALUES(4, 'Miguel', 'Sanchez Goncharov', 18, 10, '2020-01-01', 6000);

-- We can see all the information
SELECT * FROM employee_info;



-- Create different users
CREATE USER company_admin WITH PASSWORD 'GaussDB@123';
CREATE USER employee WITH PASSWORD 'GaussDB@123';
CREATE USER third_party WITH PASSWORD 'GaussDB@123';


-- Create different roles, and assign permissions based on it
CREATE ROLE admin_role IDENTIFIED BY 'GaussDB@123';
CREATE ROLE employee_role IDENTIFIED BY 'GaussDB@123';
CREATE ROLE third_party_role IDENTIFIED BY 'GaussDB@123';


-- Grant roles to users
GRANT admin_role TO company_admin;
GRANT employee_role TO employee;
GRANT third_party_role TO third_party;


-- Check granted roles
SELECT 
      r.rolname, 
      ARRAY(SELECT b.rolname
            FROM pg_catalog.pg_auth_members m
            JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
            WHERE m.member = r.oid) as memberof
FROM pg_catalog.pg_roles r
WHERE r.rolname NOT IN ('Ruby','gs_role_read_all_stats',
                        'gs_role_signal_backend')
ORDER BY 1;



-- Grant connect and usage of schema to previously created roles.
-- Note: Users does not need it
GRANT CONNECT ON DATABASE postgres TO admin_role, employee_role, third_party_role;
GRANT USAGE ON SCHEMA column_level_schema TO admin_role, employee_role, third_party_role;


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE employee_info TO admin_role;
GRANT SELECT (emp_id, name, surname, position_level, join_date) ON TABLE employee_info TO employee_role;
GRANT SELECT (emp_id, name, surname, join_date) ON TABLE employee_info TO third_party_role;


-- As admin_role, or company_admin user, we can access all the fields
SET ROLE admin_role PASSWORD 'GaussDB@123';
SELECT * FROM employee_info;

SET ROLE company_admin PASSWORD 'GaussDB@123';
SELECT * FROM employee_info;



-- As employee_role, or employee user, we can access limited fields: emp_id, name, surname, join_date
SET ROLE employee_role PASSWORD 'GaussDB@123';

SELECT * FROM employee_info;  -- This will fail

SELECT emp_id, name, surname, position_level, join_date FROM employee_info;


SET ROLE employee PASSWORD 'GaussDB@123';
SELECT emp_id, name, surname, position_level, join_date FROM employee_info;


-- As third_party_role, or third_party user, we can access limited fields: emp_id, name, surname, join_date
SET ROLE third_party_role PASSWORD 'GaussDB@123';
SELECT emp_id, name, surname, join_date FROM employee_info;
SET ROLE third_party PASSWORD 'GaussDB@123';
SELECT emp_id, name, surname, join_date FROM employee_info;




-- CLEANING
SET ROLE dbadmin PASSWORD 'SECRET_PASSWORD';
DROP SCHEMA IF EXISTS column_level_schema CASCADE;


REVOKE admin_role FROM company_admin;
REVOKE employee_role FROM employee;
REVOKE third_party_role FROM third_party;


DROP USER IF EXISTS company_admin, employee, third_party;
DROP OWNED BY admin_role, employee_role, third_party_role;
DROP ROLE IF EXISTS admin_role, employee_role, third_party_role;









