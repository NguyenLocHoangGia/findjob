CREATE DATABASE IF NOT EXISTS jobportal_intern
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE jobportal_intern;

CREATE TABLE IF NOT EXISTS roles (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_roles_name (name)
);

INSERT IGNORE INTO roles (name) VALUES
  ('ROLE_CANDIDATE'),
  ('ROLE_RECRUITER'),
  ('ROLE_ADMIN');
