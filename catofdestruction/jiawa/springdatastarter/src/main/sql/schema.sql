CREATE TABLE student(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  age INT NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO student (name, age) VALUES ("zhangsan", 20);
INSERT INTO student (name, age) VALUES ("lisi", 21);
INSERT INTO student (name, age) VALUES ("wangwu", 24);