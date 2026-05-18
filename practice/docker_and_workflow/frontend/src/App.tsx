import { useEffect, useMemo, useState } from 'react';
import { createTask, deleteTask, fetchTasks, toggleTask, updateTask } from './lib/api';
import type { Task, TaskPayload, TaskPriority, TaskStatus } from './lib/types';
import { TaskForm } from './components/TaskForm';
import { TaskList } from './components/TaskList';
import { TaskStats } from './components/TaskStats';

type FilterMode = 'all' | TaskStatus;

const priorityOrder: Record<TaskPriority, number> = {
  high: 0,
  medium: 1,
  low: 2
};

export default function App() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [selectedTask, setSelectedTask] = useState<Task | null>(null);
  const [filter, setFilter] = useState<FilterMode>('all');
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    async function loadTasks() {
      try {
        const data = await fetchTasks();
        if (active) {
          setTasks(data);
        }
      } catch (loadError) {
        if (active) {
          setError(loadError instanceof Error ? loadError.message : 'Failed to load tasks');
        }
      } finally {
        if (active) {
          setLoading(false);
        }
      }
    }

    void loadTasks();

    return () => {
      active = false;
    };
  }, []);

  const filteredTasks = useMemo(() => {
    const visible = filter === 'all' ? tasks : tasks.filter((task) => task.status === filter);

    return [...visible].sort((left, right) => {
      const priorityDifference = priorityOrder[left.priority] - priorityOrder[right.priority];
      if (priorityDifference !== 0) {
        return priorityDifference;
      }

      return right.updatedAt.localeCompare(left.updatedAt);
    });
  }, [filter, tasks]);

  async function handleSubmit(payload: TaskPayload) {
    setError(null);
    setBusyId(selectedTask?.id ?? 'creating');

    try {
      if (selectedTask) {
        const updated = await updateTask(selectedTask.id, payload);
        setTasks((current) => current.map((task) => (task.id === updated.id ? updated : task)));
        setSelectedTask(null);
        return;
      }

      const created = await createTask(payload);
      setTasks((current) => [created, ...current]);
    } catch (submitError) {
      setError(submitError instanceof Error ? submitError.message : 'Unable to save task');
    } finally {
      setBusyId(null);
    }
  }

  async function handleToggle(task: Task) {
    setError(null);
    setBusyId(task.id);

    try {
      const updated = await toggleTask(task.id);
      setTasks((current) => current.map((entry) => (entry.id === updated.id ? updated : entry)));
      if (selectedTask?.id === task.id) {
        setSelectedTask(updated);
      }
    } catch (toggleError) {
      setError(toggleError instanceof Error ? toggleError.message : 'Unable to update task');
    } finally {
      setBusyId(null);
    }
  }

  async function handleDelete(task: Task) {
    setError(null);
    setBusyId(task.id);

    try {
      await deleteTask(task.id);
      setTasks((current) => current.filter((entry) => entry.id !== task.id));
      if (selectedTask?.id === task.id) {
        setSelectedTask(null);
      }
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : 'Unable to delete task');
    } finally {
      setBusyId(null);
    }
  }

  return (
    <main className="shell">
      <div className="background-glow background-glow--left" />
      <div className="background-glow background-glow--right" />

      <header className="hero panel">
        <div>
          <p className="eyebrow">TaskFlow Studio</p>
          <h1>Build, ship, and containerize a clean task app.</h1>
          <p className="hero-copy">
            A moderate full-stack project with a React frontend, an Express API, and a layout that is easy to turn into Docker,
            Docker Compose, and GitHub Actions practice later.
          </p>
        </div>

        <div className="hero-badge">
          <span>Backend</span>
          <strong>Express + TypeScript</strong>
          <span>Frontend</span>
          <strong>React + Vite</strong>
        </div>
      </header>

      {error ? <div className="panel error-banner">{error}</div> : null}

      <TaskStats tasks={tasks} />

      <section className="controls panel">
        <div className="filter-group">
          {(['all', 'todo', 'in-progress', 'done'] as const).map((mode) => (
            <button
              key={mode}
              type="button"
              className={filter === mode ? 'filter-button active' : 'filter-button'}
              onClick={() => setFilter(mode)}
            >
              {mode === 'all' ? 'All' : mode === 'in-progress' ? 'In progress' : mode.charAt(0).toUpperCase() + mode.slice(1)}
            </button>
          ))}
        </div>

        <button type="button" className="ghost-button" onClick={() => setSelectedTask(null)}>
          New task
        </button>
      </section>

      <section className="content-grid">
        <TaskForm
          selectedTask={selectedTask}
          onSubmit={handleSubmit}
          onClear={() => setSelectedTask(null)}
          busy={busyId !== null && (selectedTask ? busyId === selectedTask.id : busyId === 'creating')}
        />

        <div className="list-column">
          <div className="list-header panel">
            <div>
              <p className="eyebrow">Tasks</p>
              <h2>{loading ? 'Loading...' : `${filteredTasks.length} item${filteredTasks.length === 1 ? '' : 's'}`}</h2>
            </div>
          </div>

          <TaskList
            tasks={filteredTasks}
            onToggle={handleToggle}
            onEdit={setSelectedTask}
            onDelete={handleDelete}
            busyId={busyId}
          />
        </div>
      </section>
    </main>
  );
}