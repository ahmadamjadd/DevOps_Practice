import type { Task, TaskPayload } from './types';

const baseUrl = import.meta.env.VITE_API_URL ?? 'http://localhost:4000';

async function parseResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    const body = (await response.json().catch(() => null)) as { message?: string } | null;
    throw new Error(body?.message ?? 'Request failed');
  }

  if (response.status === 204) {
    return undefined as T;
  }

  return response.json() as Promise<T>;
}

export async function fetchTasks(): Promise<Task[]> {
  const response = await fetch(`${baseUrl}/api/tasks`);
  const data = await parseResponse<{ tasks: Task[] }>(response);
  return data.tasks;
}

export async function createTask(payload: TaskPayload): Promise<Task> {
  const response = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  const data = await parseResponse<{ task: Task }>(response);
  return data.task;
}

export async function updateTask(id: string, payload: Partial<TaskPayload> & { status?: Task['status'] }): Promise<Task> {
  const response = await fetch(`${baseUrl}/api/tasks/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  const data = await parseResponse<{ task: Task }>(response);
  return data.task;
}

export async function deleteTask(id: string): Promise<void> {
  const response = await fetch(`${baseUrl}/api/tasks/${id}`, { method: 'DELETE' });
  await parseResponse<void>(response);
}

export async function toggleTask(id: string): Promise<Task> {
  const response = await fetch(`${baseUrl}/api/tasks/${id}/toggle`, {
    method: 'PATCH'
  });

  const data = await parseResponse<{ task: Task }>(response);
  return data.task;
}