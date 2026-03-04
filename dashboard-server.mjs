import express from 'express';
import { spawn } from 'child_process';
import os from 'os';
import fs from 'fs';

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(express.json());
app.use(express.static('public'));

// API Routes

// معلومات النظام
app.get('/api/system', (req, res) => {
  const uptime = os.uptime();
  const totalMem = os.totalmem();
  const freeMem = os.freemem();
  const usedMem = totalMem - freeMem;
  const cpus = os.cpus();

  res.json({
    uptime: formatUptime(uptime),
    memory: {
      total: formatBytes(totalMem),
      used: formatBytes(usedMem),
      free: formatBytes(freeMem),
      percentage: Math.round((usedMem / totalMem) * 100)
    },
    cpu: {
      count: cpus.length,
      model: cpus[0]?.model || 'Unknown'
    },
    platform: {
      os: os.platform(),
      arch: os.arch(),
      release: os.release()
    }
  });
});

// حالة الخدمات
app.get('/api/services', async (req, res) => {
  const services = [
    { name: 'SSH', port: 22, url: '' },
    { name: 'Nginx', port: 80, url: '/' },
    { name: 'Web Terminal', port: 7681, url: '/terminal' },
    { name: 'Cockpit', port: 9090, url: '/cockpit' },
    { name: 'PostgreSQL', port: 5432, url: '' },
    { name: 'MySQL', port: 3306, url: '' },
    { name: 'Redis', port: 6379, url: '' },
    { name: 'MongoDB', port: 27017, url: '' }
  ];

  const status = await Promise.all(
    services.map(async (service) => ({
      ...service,
      status: await checkPort(service.port)
    }))
  );

  res.json(status);
});

// تنفيذ أوامر النظام
app.post('/api/exec', express.json(), (req, res) => {
  const { command } = req.body;

  if (!command) {
    return res.status(400).json({ error: 'Command is required' });
  }

  try {
    const child = spawn('bash', ['-c', command], {
      timeout: 30000,
      maxBuffer: 10 * 1024 * 1024
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    child.stderr.on('data', (data) => {
      stderr += data.toString();
    });

    child.on('close', (code) => {
      res.json({
        code,
        stdout,
        stderr
      });
    });

    setTimeout(() => {
      child.kill();
      res.status(408).json({ error: 'Command timeout' });
    }, 30000);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// معلومات الخدمات الفردية
app.get('/api/services/:service/status', async (req, res) => {
  const { service } = req.params;
  let command;

  switch (service.toLowerCase()) {
    case 'postgresql':
      command = 'pg_isready -h localhost';
      break;
    case 'redis':
      command = 'redis-cli ping';
      break;
    case 'mysql':
      command = 'mysqladmin -u root ping 2>/dev/null || echo "Connection failed"';
      break;
    case 'mongodb':
      command = 'mongo --eval "db.adminCommand(\'ping\')" 2>/dev/null || echo "Connection failed"';
      break;
    default:
      return res.status(400).json({ error: 'Unknown service' });
  }

  try {
    const child = spawn('bash', ['-c', command], { timeout: 5000 });

    let output = '';

    child.stdout.on('data', (data) => {
      output += data.toString();
    });

    child.stderr.on('data', (data) => {
      output += data.toString();
    });

    child.on('close', (code) => {
      res.json({
        service,
        status: code === 0 ? 'running' : 'stopped',
        message: output
      });
    });
  } catch (error) {
    res.json({
      service,
      status: 'error',
      message: error.message
    });
  }
});

// تحميل الملفات
app.post('/api/files/upload', express.raw({ limit: '100mb' }), (req, res) => {
  const { filename } = req.query;

  if (!filename) {
    return res.status(400).json({ error: 'Filename is required' });
  }

  try {
    fs.writeFileSync(`/app/${filename}`, req.body);
    res.json({ message: 'File uploaded successfully', filename });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// قائمة الملفات
app.get('/api/files', (req, res) => {
  try {
    const files = fs.readdirSync('/app').map((file) => {
      const fullPath = `/app/${file}`;
      const stats = fs.statSync(fullPath);
      return {
        name: file,
        size: formatBytes(stats.size),
        modified: new Date(stats.mtime).toLocaleString(),
        isDirectory: stats.isDirectory()
      };
    });

    res.json(files);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Utility functions

function checkPort(port) {
  return new Promise((resolve) => {
    const client = require('net').createConnection(
      { port, host: 'localhost', timeout: 1000 },
      () => {
        client.destroy();
        resolve(true);
      }
    );

    client.on('error', () => {
      resolve(false);
    });

    client.on('timeout', () => {
      client.destroy();
      resolve(false);
    });
  });
}

function formatBytes(bytes) {
  if (bytes === 0) return '0 Bytes';

  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

function formatUptime(seconds) {
  const days = Math.floor(seconds / 86400);
  const hours = Math.floor((seconds % 86400) / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);

  const parts = [];
  if (days > 0) parts.push(`${days}d`);
  if (hours > 0) parts.push(`${hours}h`);
  if (minutes > 0) parts.push(`${minutes}m`);

  return parts.join(' ') || '< 1m';
}

// 404
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Web Dashboard running on http://localhost:${PORT}`);
});
