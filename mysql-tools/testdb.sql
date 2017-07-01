CREATE DATABASE char_test_db;
\u char_test_db;

DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (
  id          INT(11) NOT NULL AUTO_INCREMENT,
  description VARCHAR(50),
  PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;

SET NAMES latin1;

INSERT INTO t1 (description) VALUES ('¡Volcán!');
