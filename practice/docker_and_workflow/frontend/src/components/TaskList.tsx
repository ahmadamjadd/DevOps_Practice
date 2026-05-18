import type { Task } from '../lib/types';

interface TaskListProps {
  tasks: Task[];
  onToggle: (task: Task) => void;
  onEdit: (task: Task) => void;
  onDelete: (task: Task) => void;
  busyId: string | null;
}

const statusLabels: Record<Task['status'], string> = {
  todo: 'To do',
  'in-progress': 'In progress',
  done: 'Done'
};

const priorityLabels: Record<Task['priority'], string> = {
  low: 'Low',
  medium: 'Medium',
  high: 'High'
};

export function TaskList({ tasks, onToggle, onEdit, onDelete, busyId }: TaskListProps) {
  if (tasks.length === 0) {
    return (
      <section className="panel empty-state">
        <p className="eyebrow">No tasks yet</p>
        <h2>Start with the first task.</h2>
        <p>Create a task on the left and use it to practice Docker, Compose, and CI later.</p>
      </section>
    );
  }

  return (
    <section className="task-grid">
      {tasks.map((task) => (
        <article key={task.id} className="panel task-card">
          <div className="task-card__top">
            <div>
              <span className={`status-pill status-${task.status}`}>{statusLabels[task.status]}</span>
              <h3>{task.title}</h3>
            </div>

            <span className={`priority-pill priority-${task.priority}`}>{priorityLabels[task.priority]}</span>
          </div>

          <p className="task-description">{task.description}</p>

          <div className="task-meta">
            <span>Updated {new Date(task.updatedAt).toLocaleString()}</span>
            <span>{task.dueDate ? `Due ${new Date(task.dueDate).toLocaleDateString()}` : 'No due date'}</span>
          </div>

          <div className="task-actions">
            <button type="button" onClick={() => onToggle(task)} disabled={busyId === task.id}>
              Toggle status
            </button>
            <button type="button" onClick={() => onEdit(task)}>
              Edit
            </button>
            <button type="button" className="danger-button" onClick={() => onDelete(task)} disabled={busyId === task.id}>
              Delete
            </button>
          </div>
        </article>
      ))}
    </section>
  );
}