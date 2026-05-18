import 'dotenv/config';

const port = Number.parseInt(process.env.PORT ?? '4000', 10);

export const env = {
  port: Number.isNaN(port) ? 4000 : port,
  corsOrigin: process.env.CORS_ORIGIN ?? 'http://localhost:5173'
};