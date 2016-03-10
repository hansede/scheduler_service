CREATE EXTENSION pgcrypto;

CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  google_id varchar(1200) NOT NULL,
  name varchar(40) NOT NULL,
  email varchar(40) NOT NULL,
  phone varchar(40) NOT NULL,
  avatar varchar(300) NOT NULL,
  UNIQUE(email)
)