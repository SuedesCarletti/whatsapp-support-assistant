# Base de conhecimento (RAG)

Coloque aqui os documentos de atendimento **da sua empresa** (politicas,
FAQ, prazos, catalogo). O conteudo deste diretorio NAO e versionado
(ver `.gitignore`); so este README entra no git.

Fluxo sugerido: dividir os documentos em chunks de 300-800 tokens, gerar
embeddings e gravar na colecao `lissa-kb` do Qdrant (`http://qdrant:6333`).
