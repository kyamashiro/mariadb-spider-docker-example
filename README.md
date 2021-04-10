# Spider storage engine Dockerfile

## Overview

![](https://mariadb.com/kb/en/spider-storage-engine-overview/+image/spider_overview)

> The Spider storage engine is a storage engine with built-in sharding features. It supports partitioning and xa transactions, and allows tables of different MariaDB instances to be handled as if they were on the same instance. It refers to one possible implementation of ISO/IEC 9075-9:2008 SQL/MED.
> When a table is created with the Spider storage engine, the table links to the table on a remote server. The remote table can be of any storage engine. The table link is concretely achieved by the establishment of the connection from a local MariaDB server to a remote MariaDB server. The link is shared for all tables that are part of a the same transaction.

https://mariadb.com/kb/en/library/spider-storage-engine-overview/

## Setup

1. Create docker network.  
  `$ docker network create --gateway 192.168.10.1 --subnet 192.168.10.0/24 spider`
1. Build image.  
  `$ make build`
1. To bash into spider_node.  
  `$ make bash`
1. Install SPIDER ENGINE.  
  `$ mariadb -uroot -p$MYSQL_ROOT_PASSWORD -e "source /usr/share/mysql/install_spider.sql"`
1. Creates the definition of a server for use with the Spider.  
  `$ mariadb -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE SERVER data_node1 FOREIGN DATA WRAPPER mysql OPTIONS (USER 'root', PASSWORD 'password', HOST '192.168.10.101', PORT 3307);"`  
  `$ mariadb -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE SERVER data_node2 FOREIGN DATA WRAPPER mysql OPTIONS (USER 'root', PASSWORD 'password', HOST '192.168.10.102', PORT 3308);"`

## Usage

- Create table in spide_node.
```sql
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
```

- Create table each data_node1, 2.

```sql
CREATE TABLE employees
(
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    department_id INT(11) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;
```

- Records can be inserted on the spider_node, and they will be stored on the data_node.

```
# spider_node
MariaDB [spider_db]> INSERT INTO employees(name, department_id, created_at) VALUES ('Tom', 1, NOW()),('Jim', 2, NOW()),('Watson', 3, NOW());
Query OK, 3 rows affected (0.020 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [spider_db]> select * from employees;
+----+--------+---------------+---------------------+------------+
| id | name   | department_id | created_at          | updated_at |
+----+--------+---------------+---------------------+------------+
|  2 | Jim    |             2 | 2019-09-11 08:01:56 | NULL       |
|  1 | Tom    |             1 | 2019-09-11 08:01:56 | NULL       |
|  3 | Watson |             3 | 2019-09-11 08:01:56 | NULL       |
+----+--------+---------------+---------------------+------------+
3 rows in set (0.005 sec)

# data_node1
MariaDB [spider_db]> select * from employees;
+----+------+---------------+---------------------+------------+
| id | name | department_id | created_at          | updated_at |
+----+------+---------------+---------------------+------------+
|  2 | Jim  |             2 | 2019-09-11 08:01:56 | NULL       |
+----+------+---------------+---------------------+------------+
1 row in set (0.000 sec)

# data_node2
MariaDB [spider_db]> select * from employees;
+----+--------+---------------+---------------------+------------+
| id | name   | department_id | created_at          | updated_at |
+----+--------+---------------+---------------------+------------+
|  1 | Tom    |             1 | 2019-09-11 08:01:56 | NULL       |
|  3 | Watson |             3 | 2019-09-11 08:01:56 | NULL       |
+----+--------+---------------+---------------------+------------+
2 rows in set (0.000 sec)
```
