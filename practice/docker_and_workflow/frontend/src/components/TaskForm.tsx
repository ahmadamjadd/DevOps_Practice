import { useEffect, useMemo, useState, type FormEvent } from 'react';
import type { Task, TaskPayload, TaskPriority } from '../lib/types';

interface TaskFormProps {
  selectedTask: Task | null;
  onSubmit: (payload: TaskPayload) => Promise<void>;
  onClear: () => void;
  busy: boolean;
}

const emptyForm: TaskPayload = {
  title: '',
  description: '',
  priority: 'medium',
  dueDate: null
};

export function TaskForm({ selectedTask, onSubmit, onClear, busy }: TaskFormProps) {
  const [form, setForm] = useState<TaskPayload>(emptyForm);

  useEffect(() => {
    if (selectedTask) {
      setForm({
        title: selectedTask.title,
        description: selectedTask.description,
        priority: selectedTask.priority,
        dueDate: selectedTask.dueDate
      });
      return;
    }

    setForm(emptyForm);
  }, [selectedTask]);

  const heading = useMemo(() => (selectedTask ? 'Update task' : 'Create task'), [selectedTask]);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    await onSubmit(form);
    if (!selectedTask) {
      setForm(emptyForm);
    }
  }

  return (
    <section className="panel form-panel">
      <div className="section-heading">
        <p className="eyebrow">Planner</p>
        <h2>{heading}</h2>
      </div>

      <form className="task-form" onSubmit={handleSubmit}>
        <label>
          Title
          <input
            value={form.title}
            onChange={(event) => setForm({ ...form, title: event.target.value })}
            placeholder="Ship the backend API"
            minLength={3}
            required
          />
        </label>

        <label>
          Description
          <textarea
            value={form.description}
            onChange={(event) => setForm({ ...form, description: event.target.value })}
            placeholder="Describe the implementation and deployment plan."
            minLength={5}
            rows={4}
            required
          />
        </label>

        <div className="inline-fields">
          <label>
            Priority
            <select
              value={form.priority}
              onChange={(event) => setForm({ ...form, priority: event.target.value as TaskPriority })}
            >
              <option value="low">Low</option>
              <option value="medium">Medium</option>
              <option value="high">High</option>
            </select>
          </label>

          <label>
            Due date
            <input
              type="date"
              value={form.dueDate ? form.dueDate.slice(0, 10) : ''}
              onChange={(event) =>
                setForm({
                  ...form,
                  dueDate: event.target.value ? new Date(`${event.target.value}T00:00:00Z`).toISOString() : null
                })
              }
            />
          </label>
        </div>

        <div className="form-actions">
          <button className="primary-button" type="submit" disabled={busy}>
            {busy ? 'Saving...' : selectedTask ? 'Update task' : 'Add task'}
          </button>

          {selectedTask ? (
            <button type="button" className="ghost-button" onClick={onClear}>
              Cancel edit
            </button>
          ) : null}
        </div>
      </form>
    </section>
  );
}