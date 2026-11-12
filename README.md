# Lissa

Bot de atendimento via WhatsApp: **Evolution API + n8n + Postgres + Qdrant**,
com IA (Gemini) respondendo e memoria de conversa por telefone.
Projeto independente, sem nenhum documento ou regra de negocio de terceiros:
a base de conhecimento e o prompt sao seus.

## Stack
| Servico | Porta local | Funcao |
|---|---|---|
| n8n | 5679 | Orquestracao dos fluxos |
| Evolution API | 8080 | Gateway WhatsApp (QR code, envio, webhook) |
| Postgres | interno | `lissa` (n8n + estado) e `evolution_db` |
| Qdrant | 6333 | Base de conhecimento vetorial (RAG) |

## Subir
```bash
cp .env.example .env        # preencha GEMINI_API_KEY (os demais ja podem ser gerados)
docker compose up -d
docker compose exec -T postgres sh -c 'for f in /sql/*.sql; do psql -U lissa -d lissa -f "$f"; done'
```
1. Abra `http://localhost:5679`, crie o usuario owner e importe `workflows/lissa-base.json`.
2. Em cada no Postgres, crie/selecione a credencial (host `postgres`, db `lissa`, user `lissa`).
3. Crie a instancia na Evolution e conecte o numero (use um **numero de teste**):
   ```bash
   curl -X POST http://localhost:8080/instance/create -H "apikey: $EVOLUTION_API_KEY" \
     -H 'Content-Type: application/json' \
     -d '{"instanceName":"lissa","integration":"WHATSAPP-BAILEYS","qrcode":true}'
   ```
4. Configure o webhook da instancia para `http://n8n:5678/webhook/lissa-evolution`
   (evento `MESSAGES_UPSERT`) e ative o workflow.

## Fluxo base (`workflows/lissa-base.json`)
`Webhook -> extrai mensagem -> ignora grupos/fromMe -> [log bruto | busca estado] -> Gemini -> responde -> salva estado`

Licoes aplicadas desde o inicio: nos que leem dados usam referencia explicita
(`$('No').first().json`) em vez de `$json` solto apos Postgres/HTTP; `cron`
sempre com 5 campos; falha da IA cai em atendimento humano em vez de silencio.

## Proximos passos
- Substituir o prompt em `Montar Prompt` pelo da sua empresa.
- Popular `docs/base-conhecimento/` e indexar no Qdrant (colecao `lissa-kb`).
- Adicionar menu/regex deterministico para opcoes numericas antes da IA.
- Handoff humano: ignorar mensagens quando `current_step = 'atendimento_humano'`.
