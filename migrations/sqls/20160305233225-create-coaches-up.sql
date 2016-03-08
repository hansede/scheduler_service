CREATE TABLE coaches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(40) NOT NULL,
  email varchar(40) NOT NULL,
  phone varchar(40) NOT NULL,
  avatar varchar(40) NOT NULL,
  UNIQUE(email)
)