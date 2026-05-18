import { Router } from 'express';
import { z } from 'zod';
import { ApiError } from '../middleware/errorHandler.js';
import { taskStore } from '../store/taskStore.js';
import type { TaskPriority, TaskStatus } from '../types.js';

const taskSchema = z.object({
  title: z.string().min(3).max(80),
  description: z.string().min(5).max(240),
  priority: z.enum(['low', 'medium', 'high']),
  dueDate: z.string().datetime().nullable().optional()
});

const updateSchema = taskSchema.partial().extend({
  status: z.enum(['todo', 'in-progress', 'done']).optional()
});

export const taskRouter = Router();

taskRouter.get('/', (_request, response) => {
  response.json({ tasks: taskStore.list() });
});

taskRouter.get('/:id', (request, response, next) => {
  const task = taskStore.findById(request.params.id);

  if (!task) {
    next(new ApiError(404, 'Task not found'));
    return;
  }

  response.json({ task });
});

taskRouter.post('/', (request, response, next) => {
  const parsed = taskSchema.safeParse(request.body);

  if (!parsed.success) {
    next(new ApiError(400, parsed.error.issues[0]?.message ?? 'Invalid task payload'));
    return;
  }

  const task = taskStore.create({
    title: parsed.data.title,
    description: parsed.data.description,
    priority: parsed.data.priority as TaskPriority,
    dueDate: parsed.data.dueDate ?? null
  });

  response.status(201).json({ task });
});

taskRouter.put('/:id', (request, response, next) => {
  const parsed = updateSchema.safeParse(request.body);

  if (!parsed.success) {
    next(new ApiError(400, parsed.error.issues[0]?.message ?? 'Invalid task payload'));
    return;
  }

  const updated = taskStore.update(request.params.id, {
    title: parsed.data.title,
    description: parsed.data.description,
    priority: parsed.data.priority as TaskPriority | undefined,
    status: parsed.data.status as TaskStatus | undefined,
    dueDate: parsed.data.dueDate
  });

  if (!updated) {
    next(new ApiError(404, 'Task not found'));
    return;
  }

  response.json({ task: updated });
});

taskRouter.patch('/:id/toggle', (request, response, next) => {
  const current = taskStore.findById(request.params.id);

  if (!current) {
    next(new ApiError(404, 'Task not found'));
    return;
  }

  const nextStatus: TaskStatus = current.status === 'done' ? 'todo' : 'done';
  const updated = taskStore.update(request.params.id, { status: nextStatus });
  response.json({ task: updated });
});

taskRouter.delete('/:id', (request, response, next) => {
  const deleted = taskStore.delete(request.params.id);

  if (!deleted) {
    next(new ApiError(404, 'Task not found'));
    return;
  }

  response.status(204).send();
});