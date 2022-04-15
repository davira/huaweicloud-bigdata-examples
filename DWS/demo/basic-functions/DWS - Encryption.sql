/*
	Data Warehouse (DWS) on Huawei Cloud
	Data encryption sample
	@Author: David
	@Date: 20220415

	For more details, please check: 
	https://support.huaweicloud.com/intl/en-us/sqlreference-dws/dws_06_0048.html
*/

-- Create Schema
DROP SCHEMA IF EXISTS data_encryption CASCADE;
CREATE SCHEMA data_encryption;
SET CURRENT_SCHEMA = data_encryption;


-- Create Table with intelligence agents secret information
DROP TABLE IF EXISTS data_encryption.intelligence_agent;
CREATE TABLE data_encryption.intelligence_agent (
	id 						varchar(16),
	alias 					varchar(256),
	name 					varchar(256),
	password 				varchar(256),
	phone_no 				varchar(256),
	salary 					numeric(100,4),
	birthday 				varchar(256),
	notes 					text,
	is_secret_agent			bool
)
WITH (ORIENTATION = COLUMN)
DISTRIBUTE BY HASH(id);



-- Insert data into table
-- Only secret agent data is encrypted
-- We encrypt using gs_encrypt_aes128 using <strong_key_!@$#> as the key to encrypt data

INSERT INTO data_encryption.intelligence_agent
VALUES('d365500', 'Brother Plaza', 'David Sanchez', 'unsecure_password', '17722000000', 1500, '1986-11-06', 'Lab Clerk', false);
INSERT INTO data_encryption.intelligence_agent 
VALUES('007', 'James Bond', gs_encrypt_aes128('Daniel Craig','strong_key_!@$#'), gs_encrypt_aes128('&hef!c#U0Yq6rfzcdKJf','strong_key_!@$#'), gs_encrypt_aes128('13510000000','strong_key_!@$#'), 60000, gs_encrypt_aes128('1968-03-02','strong_key_!@$#'), 'Secret Agent - Undercover', true);
INSERT INTO data_encryption.intelligence_agent 
VALUES('M', 'Olivia Mansfield', gs_encrypt_aes128('Judi Dench','strong_key_!@$#'), gs_encrypt_aes128('?3Nw?jDtX#31puO7B6zu','strong_key_!@$#'), gs_encrypt_aes128('18670000000','strong_key_!@$#'), 120000, gs_encrypt_aes128('1934-12-09','strong_key_!@$#'), 'Secret Agent - Leader', true);


-- Normal people cannot access to all information
SELECT * 
FROM data_encryption.intelligence_agent;


-- You can access all data if you decrypt the information
SELECT 
	id, 
	alias,
    CASE
        WHEN is_secret_agent
        THEN gs_decrypt_aes128(name,'strong_key_!@$#')
        ELSE name
    END AS name,
	CASE
        WHEN is_secret_agent
        THEN gs_decrypt_aes128(password,'strong_key_!@$#')
        ELSE password
    END AS password,
    CASE
        WHEN is_secret_agent
        THEN gs_decrypt_aes128(phone_no,'strong_key_!@$#')
        ELSE phone_no
    END AS phone_no,
    salary,
    CASE
        WHEN is_secret_agent
        THEN gs_decrypt_aes128(birthday,'strong_key_!@$#')
        ELSE birthday
    END AS birthday,
    notes,
    is_secret_agent
FROM data_encryption.intelligence_agent;



/*
	gs_encrypt
	Using generic encryption function gs_encrypt(encryptstr, keystr, cryptotype, cryptomode, hashmethod)
	Description: Encrypts an <encryptstr> string using the <keystr> key, based on the encryption algorithm specified by <cryptotype> and <cryptomode> 
	and the HMAC algorithm specified by <hashmethod>
	@cryptotype can be aes128, aes192, aes256, or sm4. 
	@cryptomode is cbc. 
	@hashmethod can be sha256, sha384, sha512, or sm3. 
	
*/

DROP TABLE IF EXISTS data_encryption.crypto_table;
CREATE TABLE data_encryption.crypto_table(
	encryptstr text,
	keystr text,
	cryptotype text,
	cryptomode text,
	hashmethod text,
	encrypted_message text
);

-- Insert some sample data
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes128', 'cbc',  'sha256', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes128', 'cbc',  'sha256'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes192', 'cbc',  'sha256', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes192', 'cbc',  'sha256'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha256', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha256'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'sm4'	, 'cbc',  'sha256', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'sm4'	, 'cbc',  'sha256'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha384', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha384'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha512', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sha512'));
INSERT INTO data_encryption.crypto_table VALUES('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sm3', 
									 gs_encrypt('GaussDB on Huawei Cloud!', 'password', 'aes256', 'cbc',  'sm3'));


-- Access encryption sample data
SELECT 
	*, 
	gs_decrypt(encrypted_message, keystr, cryptotype, cryptomode, hashmethod) as "Decrypted Message"
FROM data_encryption.crypto_table;




/*
	Hash Generator
	Supported algorithms - sha256, sha384, sha512, or sm3 
	
	Use online Hash Generator to prove: https://www.onlinewebtoolkit.com/hash-generator
*/

SELECT gs_hash('GaussDB on Huawei Cloud!', 'sha256');



-- Other functions
SELECT gs_password_deadline();
SELECT gs_password_expiration();








