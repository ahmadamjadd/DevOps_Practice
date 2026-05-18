# DevOps CI/CD Lab Exercises (GitHub Actions)

## Overview
This lab series is designed to take you from basic GitHub Actions usage to intermediate CI/CD pipeline concepts, including job dependencies, conditional execution, secrets management, and deployment simulation.

---

# Lab 1: Your First GitHub Action

### Objective
Understand how to trigger a workflow manually and execute basic commands.

## Tasks
1. Create a workflow file `.github/workflows/lab1.yml`
2. Configure:
   - Trigger: `workflow_dispatch`
3. Add steps:
   - Checkout repository
   - Print contents of a file (`firstfile.txt`)
   - Print current date and time

## Challenge
- Add another step to print the current branch name using GitHub context.

---

# Lab 2: Event-Based CI Pipeline

### Objective
Trigger workflows automatically on repository events.

## Tasks
1. Create workflow triggered on:
   - `push`
   - `pull_request`
2. Add:
   - Dynamic `run-name` using:
     - actor
     - event name
     - branch
3. Add two jobs:
   - Job 1: Print repository details
   - Job 2: Echo a custom message

## Challenge
- Modify workflow to run only on `main` branch.

---

# Lab 3: Branch-Based Workflow Control

### Objective
Control workflow execution using branch filters.

## Tasks
1. Configure workflow to run only on:
   - `feature/*` branches
2. Add steps:
   - List all files
   - Print a specific file

## Challenge
- Add another branch pattern: `bugfix/*`

---

# Lab 4: Job Dependencies & Failure Handling

### Objective
Understand job dependencies and failure handling.

## Tasks
1. Create 3 jobs:
   - Job 1: Runs successfully
   - Job 2: Intentionally fails (try reading non-existent file)
   - Job 3:
     - Depends on Job 2
     - Uses `if: always()`

2. In Job 3:
   - Print whether Job 2 failed or succeeded

## Challenge
- Add separate steps for:
  - Success notification
  - Failure notification

---

# Lab 5: Secrets and Notifications

### Objective
Use GitHub secrets and send notifications.

## Tasks
1. Add repository secrets:
   - SMTP_HOST
   - SMTP_USERNAME
   - SMTP_PASSWORD

2. Use email action:
   - Send email after workflow execution
   - Include:
     - Repository name
     - Job result
     - Workflow URL

## Challenge
- Send email only when the job fails

---

# Lab 6: Conditional Execution

### Objective
Use conditions to control job execution.

## Tasks
1. Create workflow with:
   - `push`
   - `workflow_dispatch`

2. Add job that runs ONLY when:
   - Trigger is manual (`workflow_dispatch`)

3. Install:
   - PHP
   - Node.js

4. Print versions

## Challenge
- Add condition to run job only on `main` branch.

---

# Lab 7: Build and Artifact Management

### Objective
Understand build process and artifact storage.

## Tasks
1. Create a simple Node.js project
2. Add workflow:
   - Install dependencies (`npm install`)
   - Run build script (`npm run build`)
3. Upload build output as artifact

## Challenge
- Add another job to download and display artifact contents

---

# Lab 8: Simulated Deployment Pipeline

### Objective
Simulate a complete CI/CD pipeline.

## Tasks
1. Create 3 stages:
   - Build
   - Test
   - Deploy

2. Configure:
   - Deploy runs only if previous jobs succeed

3. Deployment step:
   - Echo "Deploying application..."

## Challenge
- Restrict deployment to `main` branch only

---

# Capstone Lab: Complete CI/CD Pipeline

## Objective
Build a real-world CI/CD pipeline for an application.

## Tasks
1. Create a Node.js application
2. Design a workflow with:
   - Build stage
   - Test stage
   - Artifact upload
   - Deployment simulation

3. Add:
   - Branch protection (deploy only on `main`)
   - Failure notifications (email or logs)

## Bonus Challenge
- Add environment-based deployment:
  - `dev`
  - `staging`
  - `production`

---