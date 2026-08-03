-- ==========================================
-- eDiscovery Analytics Database Schema
-- Author: Anish Ranjan
-- ==========================================

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    country VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE
);
