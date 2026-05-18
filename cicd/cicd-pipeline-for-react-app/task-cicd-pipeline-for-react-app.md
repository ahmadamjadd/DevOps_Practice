## Task: CI/CD Pipeline for React Application Deployment

- Upload the provided simple React counter application to your own GitHub repository.

- Your task is to design and implement a complete CI/CD pipeline that automates the following workflow:


### Requirements

1. **Trigger**
   - The pipeline should run automatically on every push to the `main` branch  
   - Assume all changes are merged via pull requests

2. **Code Quality Checks**
   - Run all available **unit tests** in the application
   - Validate **linting** to ensure code quality standards

3. **Build**
   - Build the React application
   - Ensure the app is built with:
     ```bash
     PUBLIC_URL=/
     ```
   - This ensures compatibility when deploying at the root (`/`)

4. **Deployment**
   - Deploy the built application to an :contentReference[oaicite:0]{index=0} instance
   - Ensure files are placed correctly so the app is accessible via browser

5. **Notification**
   - Send a notification (e.g., email or other service) indicating:
     - Success ✅
     - Failure ❌

### Expected Outcome

- A fully automated CI/CD pipeline
- Code is tested, linted, built, and deployed on every push to `main`
- Application is accessible from the EC2 instance
- Notifications are triggered based on pipeline status
