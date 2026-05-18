import cors from 'cors';
import express from 'express';
import { env } from './config/env.js';
import { errorHandler, notFoundHandler } from './middleware/errorHandler.js';
import { taskRouter } from './routes/tasks.js';

export function createApp() {
  const app = express();

  app.use(cors({ origin: env.corsOrigin }));
  app.use(express.json());

  app.get('/health', (_request, response) => {
    response.json({ status: 'ok', service: 'taskflow-backend' });
  });

  app.get('/api', (_request, response) => {
    response.json({ message: 'TaskFlow API is running' });
  });

  app.use('/api/tasks', taskRouter);
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}