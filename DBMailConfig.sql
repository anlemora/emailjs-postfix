GRANT SELECT ON servermail.* TO 'usermail'@'127.0.0.1' IDENTIFIED BY 'mailpassword';

FLUSH PRIVILEGES;

USE servermail;

DROP TABLE IF EXISTS virtual_users CASCADE;
DROP TABLE IF EXISTS virtual_aliases CASCADE;
DROP TABLE IF EXISTS virtual_domains CASCADE;

CREATE TABLE virtual_domains (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE virtual_users (
id INT NOT NULL AUTO_INCREMENT,
domain_id INT NOT NULL,
password VARCHAR(106) NOT NULL,
email VARCHAR(120) NOT NULL,
PRIMARY KEY (id),
UNIQUE KEY email (email),
FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE virtual_aliases (
id INT NOT NULL AUTO_INCREMENT,
domain_id INT NOT NULL,
source varchar(100) NOT NULL,
destination varchar(100) NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO servermail.virtual_domains
(id, name)
VALUES
('1', 'example1.com'),
('2', 'mail.example1.com'),
('3', 'example2.com'),
('4', 'mail.example2.com'),
('5', 'example3.com'),
('6', 'mail.example3.com');

INSERT INTO servermail.virtual_users
(id, domain_id, password, email)
VALUES
('1', '1', ENCRYPT('adminpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'admin@example1.com'),
('2', '1', ENCRYPT('contactpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'contact@example1.com'),
('3', '3', ENCRYPT('adminpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'admin@example2.com'),
('4', '3', ENCRYPT('contactpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'contact@example2.com'),
('5', '5', ENCRYPT('adminpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'admin@example3.com'),
('6', '5', ENCRYPT('contactpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'contact@example3.com');

INSERT INTO servermail.virtual_aliases
(id, domain_id, source, destination)
VALUES
('1', '1', 'root@example1.com', 'admin@example1.com'),
('2', '3', 'root@example2.com', 'admin@example2.com'),
('3', '5', 'root@example3.com', 'admin@example3.com');
