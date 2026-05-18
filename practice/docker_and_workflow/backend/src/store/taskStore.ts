import { randomUUID } from 'node:crypto';
import type { Task, TaskPriority, TaskStatus } from '../types.js';

export interface CreateTaskInput {
  title: string;
  description: string;
  priority: TaskPriority;
  dueDate: string | null;
}

export interface UpdateTaskInput {
  title?: string;
  description?: string;
  priority?: TaskPriority;
  status?: TaskStatus;
  dueDate?: string | null;
}

class TaskStore {
  private tasks: Task[] = [
    {
      id: randomUUID(),
      title: 'Prepare Dockerfile',
      description: 'Create a backend image that builds TypeScript and runs the API.',
      status: 'in-progress',
      priority: 'high',
      dueDate: null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    {
      id: randomUUID(),
      title: 'Add Compose file',
      description: 'Wire frontend and backend together using a shared network.',
      status: 'todo',
      priority: 'medium',
      dueDate: null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ];

  list(): Task[] {
    return [...this.tasks].sort((left, right) => right.updatedAt.localeCompare(left.updatedAt));
  }

  findById(id: string): Task | undefined {
    return this.tasks.find((task) => task.id === id);
  }

  create(input: CreateTaskInput): Task {
    const now = new Date().toISOString();
    const task: Task = {
      id: randomUUID(),
      title: input.title,
      description: input.description,
      priority: input.priority,
      status: 'todo',
      dueDate: input.dueDate,
      createdAt: now,
      updatedAt: now
    };

    this.tasks = [task, ...this.tasks];
    return task;
  }

  update(id: string, input: UpdateTaskInput): Task | undefined {
    const current = this.findById(id);

    if (!current) {
      return undefined;
    }

    const updated: Task = {
      ...current,
      ...input,
      updatedAt: new Date().toISOString()
    };

    this.tasks = this.tasks.map((task) => (task.id === id ? updated : task));
    return updated;
  }

  delete(id: string): boolean {
    const nextLength = this.tasks.filter((task) => task.id !== id).length;
    const deleted = nextLength !== this.tasks.length;
    this.tasks = this.tasks.filter((task) => task.id !== id);
    return deleted;
  }
}

export const taskStore = new TaskStore();