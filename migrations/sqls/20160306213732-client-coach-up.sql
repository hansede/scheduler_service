CREATE TABLE client_coach (
  client_id UUID REFERENCES clients (id),
  coach_id UUID REFERENCES coaches (id),
  UNIQUE(client_id)
)