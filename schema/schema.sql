-- ==========================================
-- eDiscovery Analytics Database Schema
-- Author: Anish Ranjan
-- ==========================================

-- ==========================================
-- Clients Table
-- ==========================================
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    country VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE
);

-- ==========================================
-- Cases Table
-- ==========================================
CREATE TABLE cases (
    case_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    case_name VARCHAR(200) NOT NULL,
    case_status VARCHAR(20) NOT NULL,
    priority VARCHAR(20),
    opened_date DATE NOT NULL,
    closed_date DATE,

    CONSTRAINT fk_client
        FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
);

-- ==========================================
-- Custodians Table
-- ==========================================
CREATE TABLE custodians (
    custodian_id SERIAL PRIMARY KEY,
    case_id INTEGER NOT NULL,
    custodian_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    department VARCHAR(50),
    country VARCHAR(50),

    CONSTRAINT fk_case
        FOREIGN KEY (case_id)
        REFERENCES cases(case_id)
);

-- ==========================================
-- Uploads Table
-- ==========================================
CREATE TABLE uploads (
    upload_id SERIAL PRIMARY KEY,
    case_id INTEGER NOT NULL,
    custodian_id INTEGER NOT NULL,
    upload_date DATE NOT NULL,
    data_size_gb DECIMAL(10,2),
    documents_uploaded INTEGER,
    processing_time_minutes INTEGER,
    processing_status VARCHAR(20),

    CONSTRAINT fk_upload_case
        FOREIGN KEY (case_id)
        REFERENCES cases(case_id),

    CONSTRAINT fk_upload_custodian
        FOREIGN KEY (custodian_id)
        REFERENCES custodians(custodian_id)
);

-- ==========================================
-- Reviewers Table
-- ==========================================
CREATE TABLE reviewers (
    reviewer_id SERIAL PRIMARY KEY,
    reviewer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    team VARCHAR(50),
    experience_years INTEGER CHECK (experience_years >= 0)
);

-- ==========================================
-- Reviews Table
-- ==========================================
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    upload_id INTEGER NOT NULL,
    reviewer_id INTEGER NOT NULL,
    review_start TIMESTAMP NOT NULL,
    review_end TIMESTAMP,
    documents_reviewed INTEGER DEFAULT 0,
    privileged_documents INTEGER DEFAULT 0,
    qc_status VARCHAR(20),
    review_status VARCHAR(20),

    CONSTRAINT fk_review_upload
        FOREIGN KEY (upload_id)
        REFERENCES uploads(upload_id),

    CONSTRAINT fk_review_reviewer
        FOREIGN KEY (reviewer_id)
        REFERENCES reviewers(reviewer_id)
);

-- ==========================================
-- SLA Tracking Table
-- ==========================================
CREATE TABLE sla_tracking (
    sla_id SERIAL PRIMARY KEY,
    case_id INTEGER NOT NULL,
    upload_id INTEGER NOT NULL,
    reviewer_id INTEGER NOT NULL,
    sla_due_date TIMESTAMP NOT NULL,
    completed_date TIMESTAMP,
    turnaround_hours DECIMAL(8,2),
    sla_status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_sla_case
        FOREIGN KEY (case_id)
        REFERENCES cases(case_id),

    CONSTRAINT fk_sla_upload
        FOREIGN KEY (upload_id)
        REFERENCES uploads(upload_id),

    CONSTRAINT fk_sla_reviewer
        FOREIGN KEY (reviewer_id)
        REFERENCES reviewers(reviewer_id)
);
