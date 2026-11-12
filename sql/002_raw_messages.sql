-- Log bruto de toda mensagem recebida no webhook (fonte confiavel p/ relatorios,
-- independente da persistencia interna da Evolution API).
CREATE TABLE IF NOT EXISTS raw_messages (
  id          TEXT PRIMARY KEY,
  phone       TEXT NOT NULL,
  from_me     BOOLEAN NOT NULL,
  text        TEXT,
  payload     JSONB,
  received_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS raw_messages_phone_idx ON raw_messages (phone, received_at);
