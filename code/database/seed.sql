USE agent_management;

INSERT INTO agents (name, description, status) VALUES
('DataCollector', 'Collects and processes data from various sources', 'idle'),
('ReportGenerator', 'Generates automated reports', 'idle'),
('MonitorAgent', 'Monitors system health and performance', 'running');

INSERT INTO tools (name, description, category) VALUES
('HTTP Client', 'Makes HTTP requests to external APIs', 'network'),
('Data Parser', 'Parses JSON and XML data', 'processing'),
('File Writer', 'Writes data to files', 'storage'),
('Database Query', 'Executes database queries', 'database'),
('Email Sender', 'Sends email notifications', 'communication');

INSERT INTO tasks (agent_id, title, description, status, priority) VALUES
(1, 'Fetch weather data', 'Collect weather information from API', 'pending', 1),
(1, 'Process user submissions', 'Parse and validate user data', 'completed', 2),
(2, 'Generate monthly report', 'Create summary of monthly activities', 'pending', 1),
(3, 'Check system status', 'Monitor CPU and memory usage', 'running', 3);

INSERT INTO logs (agent_id, task_id, level, message) VALUES
(1, 1, 'info', 'Task started successfully'),
(1, 2, 'info', 'Data validation completed'),
(1, 2, 'info', 'Task completed successfully'),
(2, 3, 'info', 'Report generation initiated'),
(3, 4, 'warning', 'High memory usage detected'),
(3, 4, 'info', 'Monitoring continues');
