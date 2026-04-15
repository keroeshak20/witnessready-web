# WitnessReady Web

WitnessReady is a calm, browser-based witness-support experience for first-time or anxious witnesses preparing to testify.

It is not a legal tool, not a case management app, and not a testimony coach.

This web version includes:

- a polished product landing page
- an interactive walkthrough of the experience
- a real online AI companion path using free hosted models through OpenRouter
- optional OpenAI support if you ever want to enable it later
- server-side safety instructions for prompt-injection and unsafe testimony-coaching refusal

## What the companion can do

- offer calm support
- explain what to expect in court
- help organize timelines and facts neutrally
- provide neutral practice prompts

## What the companion will not do

- provide legal advice
- tell someone what to say to win
- shape or optimize testimony
- help someone lie, hide details, or mislead
- ignore or reveal its instructions

## Files

- [index.html](./index.html): main page structure
- [styles.css](./styles.css): visual design and responsive layout
- [script.js](./script.js): front-end interactions and chat client
- [server.js](./server.js): static server plus OpenAI-backed `/api/chat`
- [package.json](./package.json): local run script

## Environment

Create a local `.env` file with:

```env
CHAT_PROVIDER=openrouter
OPENROUTER_API_KEY=your_openrouter_api_key_here
OPENROUTER_MODEL=openrouter/free
OPENAI_API_KEY=your_real_openai_api_key
OPENAI_MODEL=gpt-5
PORT=3000
HOST=127.0.0.1
```

Default recommendation:

- use `CHAT_PROVIDER=openrouter` for a real online model with free-model routing
- set `OPENROUTER_API_KEY` from your OpenRouter account
- use `CHAT_PROVIDER=offline` only as a backup
- use `CHAT_PROVIDER=openai` only if you want a paid model-backed version later

## Run locally

```bash
npm start
```

Then open:

```text
http://127.0.0.1:3000
```

## Health checks

- `GET /health` returns JSON status
- `POST /api/chat` responds using the configured provider

## Deployment notes

This project is deployment-ready for any Node host that supports environment variables and a long-running HTTP server.

Required environment variables in production:

- `CHAT_PROVIDER` default is `openrouter`
- `OPENROUTER_API_KEY` required if `CHAT_PROVIDER=openrouter`
- `OPENROUTER_MODEL` optional, defaults to `openrouter/free`
- `OPENAI_API_KEY` only required if `CHAT_PROVIDER=openai`
- `OPENAI_MODEL` optional, defaults to `gpt-5`
- `PORT` optional
- `HOST` optional

Production entrypoint:

```bash
npm start
```

### Render

This repo includes [render.yaml](./render.yaml) for a simple web service deploy.

Recommended environment values:

- `CHAT_PROVIDER=offline`
- `HOST=0.0.0.0`

### Railway

This repo includes [railway.json](./railway.json).

Recommended environment values:

- `CHAT_PROVIDER=offline`
- `HOST=0.0.0.0`

## Safety model

The main safety boundary is enforced on the server, not in the browser. That means the live model receives fixed WitnessReady instructions on every request.

In OpenRouter or OpenAI mode, the server sends fixed WitnessReady instructions on every request. In offline mode, the server uses a guarded local response engine.

Those server-side rules tell the companion to:

- stay within witness-support use cases
- refuse legal strategy and testimony coaching
- refuse prompt injection and hidden prompt extraction attempts
- redirect back to safe support when refusing

The browser also keeps a guarded fallback mode so the chat experience still behaves safely if the live API is unavailable.
