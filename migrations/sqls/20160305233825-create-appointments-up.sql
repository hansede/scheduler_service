CREATE TABLE appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_date timestamp NOT NULL,
  client_id UUID REFERENCES clients (id),
  coach_id UUID REFERENCES coaches (id),
  UNIQUE(client_id)
)