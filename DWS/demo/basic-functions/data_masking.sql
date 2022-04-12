/*
	Data Warehouse (DWS) on Huawei Cloud
	Data masking (data redaction) sample
	@Author: David
	@Date: 20220412

	For more details, please check: https://support.huaweicloud.com/intl/en-us/devg-dws/dws_04_0062.html
*/

-- Set role as DBadmin
-- SET ROLE dbadmin PASSWORD 'SECRET_PASSWORD';


-- Create Schema
DROP SCHEMA IF EXISTS data_masking CASCADE;
CREATE SCHEMA data_masking;
SET CURRENT_SCHEMA = data_masking;


-- Create Roles
DROP ROLE IF EXISTS david;
DROP ROLE IF EXISTS yago;
DROP ROLE IF EXISTS penny;
CREATE ROLE david PASSWORD 'Gauss@123';
CREATE ROLE yago PASSWORD 'Gauss@123';
CREATE ROLE penny PASSWORD 'Gauss@123';


-- Allow new roles with all privilages on new schema data_masking
GRANT ALL PRIVILEGES ON SCHEMA data_masking TO david, yago, penny;



-- Set role to David
SET ROLE david PASSWORD 'Gauss@123';

-- Create table with employee information
DROP TABLE IF EXISTS data_masking.employee;
CREATE TABLE data_masking.employee (
	id 						int,
	name 					varchar(20),
	phone_no 				varchar(11),
	card_no 				number,
	card_string 			varchar(19),
	email 					text,
	salary 					numeric(100,4),
	birthday 				date
)
WITH (ORIENTATION = COLUMN)
DISTRIBUTE BY HASH(id);


-- Insert some data
INSERT INTO data_masking.employee VALUES(1, 'anny', '13420002340', 1234123412341234, '1234-1234-1234-1234', 'smithWu@163.com', 10000.00, '1999-10-02');
INSERT INTO data_masking.employee VALUES(1, 'bob', '18299023211', 3456345634563456, '3456-3456-3456-3456', '66allen_mm@qq.com', 9999.99, '1989-12-12');
INSERT INTO data_masking.employee VALUES(1, 'cici', '15512231233', NULL, NULL, 'jonesishere@sina.com', NULL, '1992-11-06');


-- As David, query the table, and we can visualize all data, without masking
SET ROLE david PASSWORD 'Gauss@123';
SELECT * FROM data_masking.employee;



-- Grant permission to query the table to Yago and Penny. David, as table owner, has permissions already
GRANT SELECT ON data_masking.employee TO yago, penny;


-- Create a data masking (data redaction) policy, for Yago and Penny
CREATE REDACTION POLICY mask_employee ON employee WHEN (current_user IN ('yago', 'penny'))
ADD COLUMN card_no WITH mask_full(card_no),
ADD COLUMN card_string WITH mask_partial(card_string, 'VVVVFVVVVFVVVVFVVVV','VVVV-VVVV-VVVV-VVVV','#',1,12),
ADD COLUMN salary WITH mask_partial(salary, '9', 1, length(salary) - 2);



-- As Yago, query the table. Please notice the credit card info and salary is obfuscated
SET ROLE yago PASSWORD 'Gauss@123';
SELECT * FROM data_masking.employee;


-- As Penny, query the table. Please notice the credit card info and salary is obfuscated
SET ROLE penny PASSWORD 'Gauss@123';
SELECT * FROM employee;



-- Modify the data masking policy.
SET ROLE david PASSWORD 'Gauss@123';
ALTER REDACTION POLICY mask_employee ON employee WHEN(current_user = 'penny');


-- As Yago, query the table. Yago now can see all data
SET ROLE yago PASSWORD 'Gauss@123';
SELECT * FROM employee;


-- As Penny, query the table. Please notice the credit card info and salary is obfuscated
SET ROLE penny PASSWORD 'Gauss@123';
SELECT * FROM employee;


-- Modify the data masking policy.
SET ROLE david PASSWORD 'Gauss@123';

ALTER REDACTION POLICY mask_employee ON employee
ADD COLUMN phone_no WITH mask_partial(phone_no, '*', 4);

ALTER REDACTION POLICY mask_employee ON employee
ADD COLUMN email WITH mask_partial(email, '*', 1, position('@' in email));

ALTER REDACTION POLICY mask_employee ON employee
ADD COLUMN birthday WITH mask_full(birthday);


-- As Penny, query the table. Please notice almost all fields are encrypted
SET ROLE penny PASSWORD 'Gauss@123';
SELECT * FROM employee;



-- Modify the data masking policy.
SET ROLE david PASSWORD 'Gauss@123';


-- Query all data masking policies
SELECT * FROM redaction_policies;

-- Query all data masking columns
SELECT object_name, column_name, function_info FROM redaction_columns;

-- Drop existing data masking rules
DROP REDACTION POLICY mask_employee ON employee;




