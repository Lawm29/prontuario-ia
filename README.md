# Prontuário IA

Aplicativo web de página única (1 único arquivo `.html`) que ajuda médicos a transformar anotações rápidas de prontuário em documentação clínica detalhada, usando inteligência artificial generativa com **fallback automático entre 3 provedores gratuitos** (Gemini → Groq → OpenRouter).

## ⚠️ IMPORTANTE: Como abrir (LEIA PRIMEIRO)

> **Não abra o `index.html` com duplo clique.** O navegador bloqueia as funções de IA nesse modo (CORS).
>
> **Use o `iniciar.bat`** — ele inicia um servidor local e abre o navegador automaticamente.

### Passo a passo

1. **Instale o Python 3** (se ainda não tiver): https://www.python.org/downloads/
   - ⚠️ Durante a instalação, marque a opção **"Add Python to PATH"** (ou "Adicionar Python ao PATH"). É a primeira checkbox da primeira tela.
2. Na pasta do app, dê **duplo clique em `iniciar.bat`**.
3. Espere 2-3 segundos. Uma janela preta vai abrir (é o servidor — não feche) e o navegador vai abrir sozinho em `http://localhost:8000`.
4. Configure suas chaves de API (clique no ⚙️ no canto superior direito).
5. Use o app normalmente.
6. Para parar: feche a janela preta do servidor.

> Se algo der errado, leia o arquivo **`INICIAR-LEIA-ME.txt`** na mesma pasta — tem solução para os problemas mais comuns.

## Funcionalidades

- **Antecedentes & preferências** (no topo): idade/sexo, alergias, antecedentes, medicações em uso, aquisição (UBS/farmácia), via preferencial (EV/IM/domiciliar).
- **Seções clínicas editáveis** com botões de IA:
  - Anamnese · Exame Físico · Diagnóstico · Conduta · Exames Laboratoriais · Exames de Imagem.
- **✨ Melhorar** — reescreve o rascunho de forma técnica e detalhada, preservando 100% do que o médico escreveu.
- **🧠 Diagnósticos diferenciais + exames confirmatórios** — para o diagnóstico ou, se vazio, baseando-se na anamnese + exame físico.
- **💊 Plano terapêutico sugerido** — medicações (1ª linha, doses, vias), medidas não-farmacológicas, exames, encaminhamentos, critérios de internação, sinais de alarme.
- **💡 Sugestões adicionais** — abaixo de cada seção, itens que costumam complementar aquele registro.
- **📋 Copiar tudo / 📄 Copiar por seção / 🖨️ Imprimir** — exportação rápida.
- **🩺 Diagnóstico** (botão no topo) — mostra o estado interno do app (orquestrador, provedores, chaves, navegador) para ajudar em suporte.
- **Sem persistência em disco**: config fica só em `sessionStorage` ou em memória (nada em servidor).
- **Cadeia de fallback automática** entre 3 provedores gratuitos, sem cartão de crédito.

## Como rodar

### Método recomendado: `iniciar.bat` (Windows)

**Não clique duplo no `index.html`** — o navegador vai bloquear as funções de IA (erro "Failed to fetch" / CORS).

Em vez disso:

1. Se ainda não tem Python 3 instalado: baixe de https://www.python.org/downloads/ e **marque "Add Python to PATH"** durante a instalação.
2. **Duplo clique em `iniciar.bat`**. Ele vai:
   - Iniciar um mini servidor local (Python)
   - Abrir o navegador automaticamente em `http://localhost:8000`
3. Use o app. Para parar, feche a janela preta do servidor.

### Outros métodos

- **macOS / Linux**: abra o Terminal na pasta, rode `python3 -m http.server 8000`, e abra `http://localhost:8000` no navegador.
- **Online (GitHub Pages)**: veja a seção "Hospedagem" mais abaixo.
- **Avançado**: `npx http-server -p 8000` (precisa de Node.js).

## Como obter as chaves de API (todas gratuitas, sem cartão)

Abra o app e clique em **⚙️** no canto superior direito. Você pode configurar 1, 2 ou 3 chaves. **Quanto mais, mais redundância.**

### 1. Google Gemini (recomendado — primário)

1. Acesse https://aistudio.google.com/app/apikey
2. Faça login com uma conta Google
3. Clique em **"Create API key"** → **"Create key in new project"**
4. Copie a chave (começa com `AIzaSy…`)
5. Cole no app → **Testar** → **Salvar e fechar**

**Limites free tier:** 1.500 req/dia · 10 req/min · 250K tokens/min · 1M contexto. Sem cartão, sem expiração.

### 2. Groq (mais rápido — fallback)

1. Acesse https://console.groq.com/keys
2. Crie conta (Google/GitHub/email)
3. Clique em **"Create API Key"**
4. Copie e cole no app

**Limites free tier:** 30 req/min · ~14.400 req/dia · Llama 3.3 70B · ~315 tokens/s. Sem cartão.

### 3. OpenRouter (coringa — fallback)

1. Acesse https://openrouter.ai/keys
2. Faça login (Google/GitHub/email)
3. Clique em **"Create Key"**
4. Copie e cole no app

**Limites free tier:** 20 req/min · 50–1.000 req/dia · modelos `:free` rotativos. Sem cartão.

## Ordem da cadeia de fallback

1. **Provedor primário** (você escolhe no topo da tela)
2. Os outros 2 na ordem padrão: **Gemini → Groq → OpenRouter**

| Erro | Comportamento |
|---|---|
| 401/403 (chave inválida) | Marca o provedor como desabilitado e pula para o próximo |
| 429 (rate limit) | Marca cooldown de 1 hora e pula para o próximo |
| 5xx / falha de rede | Pula para o próximo sem desabilitar |
| Todos falham | Mensagem de erro detalhada mostrando o que cada provedor retornou |

A resposta bem-sucedida vem com um badge: **"Respondido por: Gemini"** (ou Groq / OpenRouter).

## Arquivos

```
.
├── index.html           ← app completo (HTML + CSS + JS, tudo embutido)
├── iniciar.bat          ← ATALHO: duplo clique para iniciar o servidor local
├── INICIAR-LEIA-ME.txt  ← instruções simples + troubleshooting
└── README.md            ← este arquivo
```

> Por que 1 arquivo HTML só (sem `prompts.js`/`providers.js`)? Porque abrir via `file://` tem comportamento inconsistente entre navegadores, e o `iniciar.bat` resolve servindo via HTTP local.

## Solução de Problemas

### "Failed to fetch" / "CORS bloqueado"

O navegador está bloqueando as chamadas de IA porque o app foi aberto via `file://` (clique duplo no Explorador de Arquivos).

**Solução:** use o arquivo `iniciar.bat` (veja "Como rodar" acima). Ele inicia um servidor local e libera as chamadas.

O próprio app detecta isso: ao abrir via `file://`, aparece um **banner vermelho** no topo da página com as instruções de como resolver.

### "Os botões não fazem nada"

1. Pressione **F12** no teclado (abre o painel de desenvolvedor).
2. Clique na aba **"Console"**.
3. Recarregue a página (F5).
4. Veja se aparece algum texto em **vermelho**. Se sim, copie e cole aqui.
5. Clique no botão **🩺** (diagnóstico) no topo do app. Ele mostra:
   - Se o orquestrador de IA foi inicializado
   - Se o navegador suporta `fetch` e `sessionStorage`
   - Qual provedor está configurado
   - Permite testar a chamada de IA com 1 clique

### "Aparece erro CORS ou Mixed Content"

Geralmente é o navegador bloqueando a chamada à API. Tente:
- Use **Chrome** ou **Edge** (Firefox tem políticas CORS mais restritivas em `file://`).
- Desative extensões de privacidade/anti-tracker (uBlock, Privacy Badger) na página.
- Se persistir, hospede o app no GitHub Pages (grátis) — veja "Hospedagem" abaixo.

### "Nada acontece ao clicar em '✨ Melhorar'"

Verifique se configurou uma chave de API (banner amarelo deve ter sumido). Se sumiu, pode ser:
- **Chave inválida** — clique ⚙️ e "Testar" para ver o erro detalhado.
- **Cota diária esgotada** — o app tenta automaticamente o próximo provedor. Se todos esgotaram, verá a mensagem "Todos os provedores falharam".
- **Sem internet** — as chamadas de IA precisam de conexão.
- **CORS / file://** — veja acima.

### "Esqueci de salvar o prontuário e fechei a aba"

Os dados ficam em `sessionStorage` (sai junto com a aba) e em memória. **Ao fechar a aba, tudo é perdido.** Por isso, use os botões **Copiar tudo** ou **Imprimir** antes de fechar.

## Segurança e LGPD

- Nenhuma requisição passa por servidor próprio. O browser do médico fala **diretamente** com a API escolhida, usando a chave dele.
- As chaves ficam em `sessionStorage` (memória da aba) ou em memória pura. Somem ao fechar a aba.
- Nada do prontuário é persistido localmente (nada em disco).
- O paciente não é identificado pelo nome no app; o médico pode usar idade/sexo/iniciais se preferir.

## Limitações assumidas

- A IA não acessa internet em tempo real. Usa o conhecimento do treino (cutoff: início de 2026). Para Guidelines atualizadas pós-cutoff, **sempre confirme no UpToDate / site da Sociedade Brasileira / Ministério da Saúde**.
- Modelos gratuitos ≠ GPT-5/Claude Opus em raciocínio de borda. A resposta é sempre **editável** — o médico é o revisor final.
- O app é uma **ferramenta de apoio à documentação**. A responsabilidade legal e clínica do prontuário é do médico assistente.

## Como funciona por dentro (resumo técnico)

Um único arquivo `index.html` contém 3 blocos de JavaScript:

1. **`MedicalPrompts`** — 6 construtores de prompt (anamnese, exame físico, diagnóstico, conduta, exames lab, imagem) + diferenciais + plano terapêutico. Recebem o contexto do paciente e retornam a string final enviada à IA.

2. **`AIOrchestrator`** — gerencia 3 provedores (Gemini, Groq, OpenRouter) com fallback automático. Os 3 usam endpoints **OpenAI-compat**, então compartilham a mesma forma de chamada. Trata 401/403 (desabilita), 429 (cooldown 1h), 5xx/rede (pula sem desabilitar).

3. **App UI** — bind de eventos, renderização de output, extração de sugestões do texto da IA, modal de configuração, modal de diagnóstico, copy/print/clear.

A config (chaves, provedor primário) fica em `sessionStorage` quando disponível, com fallback automático para memória pura (caso o navegador bloqueie storage em `file://`).

## Hospedagem (opcional)

Para acessar do celular ou compartilhar com outros médicos, hospede no **GitHub Pages** (grátis):

1. Crie uma conta em https://github.com
2. Crie um repositório novo (ex: `prontuario-ia`)
3. Faça upload do `index.html`
4. Em **Settings → Pages**, selecione a branch `main` e `/ (root)`. Salvar.
5. Em ~1 minuto, o app estará em `https://seu-usuario.github.io/prontuario-ia`

Como o app chama APIs externas via `fetch` direto do browser, **funciona 100% client-side** mesmo hospedado em Pages.

## Disclaimer

Esta é uma ferramenta de apoio à documentação médica. **Não substitui o julgamento clínico, o conhecimento atualizado do médico, nem a consulta às fontes primárias de referência.** Use como rascunho inteligente; revise sempre antes de anexar ao prontuário oficial.
