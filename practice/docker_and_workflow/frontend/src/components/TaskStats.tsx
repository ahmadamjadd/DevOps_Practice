import type { Task } from '../lib/types';

interface TaskStatsProps {
  tasks: Task[];
}

export function TaskStats({ tasks }: TaskStatsProps) {
  const done = tasks.filter((task) => task.status === 'done').length;
  const active = tasks.filter((task) => task.status === 'in-progress').length;
  const todo = tasks.filter((task) => task.status === 'todo').length;

  return (
    <section className="stats-row">
      <div className="panel stat-card">
        <span>Total</span>
        <strong>{tasks.length}</strong>
      </div>
      <div className="panel stat-card">
        <span>Active</span>
        <strong>{active}</strong>
      </div>
      <div className="panel stat-card">
        <span>Done</span>
        <strong>{done}</strong>
      </div>
      <div className="panel stat-card">
        <span>Todo</span>
        <strong>{todo}</strong>
      </div>
    </section>
  );
}