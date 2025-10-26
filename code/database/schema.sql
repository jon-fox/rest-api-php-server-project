DROP DATABASE IF EXISTS agent_management;
CREATE DATABASE agent_management;
USE agent_management;

CREATE TABLE agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('idle', 'running', 'paused', 'error') DEFAULT 'idle',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('pending', 'running', 'completed', 'failed') DEFAULT 'pending',
    priority INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
);

CREATE TABLE tools (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_id INT,
    task_id INT,
    level ENUM('info', 'warning', 'error', 'debug') DEFAULT 'info',
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
);

CREATE TABLE api_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(64) UNIQUE NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL
);

CREATE INDEX idx_agent_status ON agents(status);
CREATE INDEX idx_task_status ON tasks(status);
CREATE INDEX idx_task_agent ON tasks(agent_id);
CREATE INDEX idx_logs_agent ON logs(agent_id);
CREATE INDEX idx_logs_task ON logs(task_id);
CREATE INDEX idx_logs_created ON logs(created_at);
