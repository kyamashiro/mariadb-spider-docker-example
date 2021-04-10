CREATE SERVER data_node1 FOREIGN DATA WRAPPER mysql OPTIONS (USER 'root', PASSWORD 'password', HOST '192.168.10.101', PORT 3307);
CREATE SERVER data_node2 FOREIGN DATA WRAPPER mysql OPTIONS (USER 'root', PASSWORD 'password', HOST '192.168.10.102', PORT 3308);
USE spider_db;

CREATE TABLE employees
(
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    department_id INT(11) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    PRIMARY KEY (id)
) ENGINE = SPIDER DEFAULT CHARSET=utf8mb4
PARTITION BY HASH(id) (
  PARTITION p1 comment 'server "data_node1", table "employees"',
  PARTITION p2 comment 'server "data_node2", table "employees"'
);
