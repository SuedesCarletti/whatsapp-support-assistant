-- Estado atual de cada conversa (uma linha por telefone/JID).
-- data.history: ultimas mensagens [{role:'user'|'assistant', content}], mais recentes por ultimo.
CREATE TABLE IF NOT EXISTS conversation_state (
  phone        TEXT PRIMARY KEY,
  current_step TEXT NOT NULL DEFAULT 'novo',
  data         JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
