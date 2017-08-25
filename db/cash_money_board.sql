DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  budget_cap INT CHECK(budget_cap >= 0)
);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE merchants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  tag_id INT REFERENCES tags(id)
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  value INT CHECK (value > 0),
  date_time TIMESTAMP,
  user_id INT REFERENCES users(id),
  merchant_id INT REFERENCES merchants(id)
);
