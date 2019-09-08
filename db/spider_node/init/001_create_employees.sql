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
  PARTITION p1 comment 'server "data-node1", table "employees"',
  PARTITION p2 comment 'server "data-node2", table "employees"'
);