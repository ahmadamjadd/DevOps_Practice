# TaskFlow Studio

TaskFlow Studio is a moderate full-stack practice app for DevOps exams. It gives you a clean backend API, a React frontend, and a simple structure that is easy to containerize, wire into Docker Compose, and connect to GitHub Actions later.

## Stack

- Backend: Node.js, Express, TypeScript
- Frontend: React, Vite, TypeScript
- Data: in-memory task store with CRUD and status toggling

## Features

- Create, edit, delete, and toggle tasks
- Filter tasks by status and priority
- API health endpoint for container checks
- Clean separation between frontend and backend
- Environment variables for local and container setups

## Project Layout

- [backend/](backend)
- [frontend/](frontend)

## Environment

Create local env files from the examples:

- [backend/.env.example](backend/.env.example)
- [frontend/.env.example](frontend/.env.example)

## Local Run

Install dependencies at the root with npm workspaces, then run the services separately:

```bash
npm install
npm run dev:backend
npm run dev:frontend
```

Backend runs on port `4000` and frontend on port `5173` by default.

## Build Targets

The repository is already prepared for:

- a backend Docker image
- a frontend Docker image
- Docker Compose with both services
- GitHub Actions for lint/build checks

That extra infra layer can be added on top of this codebase without changing the app structure.