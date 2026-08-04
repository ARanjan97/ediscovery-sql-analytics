-- ==========================================
-- Seed Data - Clients
-- ==========================================

INSERT INTO clients (client_name, industry, country) VALUES
('Microsoft', 'Technology', 'USA'),
('Google', 'Technology', 'USA'),
('Amazon', 'Technology', 'USA'),
('Apple', 'Technology', 'USA'),
('Meta', 'Technology', 'USA'),
('JPMorgan Chase', 'Banking', 'USA'),
('Goldman Sachs', 'Banking', 'USA'),
('Morgan Stanley', 'Banking', 'USA'),
('Pfizer', 'Pharmaceuticals', 'USA'),
('Johnson & Johnson', 'Healthcare', 'USA'),
('Shell', 'Energy', 'Netherlands'),
('BP', 'Energy', 'United Kingdom'),
('Siemens', 'Manufacturing', 'Germany'),
('BMW Group', 'Automotive', 'Germany'),
('Toyota', 'Automotive', 'Japan'),
('Samsung', 'Electronics', 'South Korea'),
('Accenture', 'Consulting', 'Ireland'),
('Deloitte', 'Consulting', 'United Kingdom'),
('EY', 'Consulting', 'United Kingdom'),
('KPMG', 'Consulting', 'Netherlands');

-- ==========================================
-- Seed Data - Cases (100 Records)
-- ==========================================

INSERT INTO cases (
    client_id,
    case_name,
    case_status,
    priority,
    opened_date,
    closed_date
)
SELECT
    c.client_id,
    c.client_name || ' - ' ||
    CASE n
        WHEN 1 THEN 'Patent Litigation'
        WHEN 2 THEN 'Employment Investigation'
        WHEN 3 THEN 'GDPR Compliance Review'
        WHEN 4 THEN 'Internal Audit'
        WHEN 5 THEN 'Contract Dispute'
    END,
    'Active',
    
    'High',
    CURRENT_DATE,
    NULL
FROM clients c
CROSS JOIN generate_series(1,5) AS gs(n);

-- ==========================================
-- Seed Data - Custodians (500 Records)
-- ==========================================
INSERT INTO custodians (
    case_id,
    custodian_name,
    email,
    department,
    country
)
SELECT
    c.case_id,
    'Custodian ' || ROW_NUMBER() OVER (),
    'custodian' || ROW_NUMBER() OVER () || '@company.com',
    CASE n
        WHEN 1 THEN 'Legal'
        WHEN 2 THEN 'Finance'
        WHEN 3 THEN 'Human Resources'
        WHEN 4 THEN 'IT'
        WHEN 5 THEN 'Compliance'
    END,
    'USA'
FROM cases AS c
CROSS JOIN generate_series(1,5) AS gs(n);

-- ==========================================
-- Seed Data - Reviewers (25 Records)
-- ==========================================

INSERT INTO reviewers (
    reviewer_name,
    team,
    experience_years,
    email,
    user_id
)
VALUES
('Alice Johnson', 'Team Alpha', 8, 'alice.johnson@ediscovery.com', 'RVW001'),
('Brian Smith', 'Team Alpha', 6, 'brian.smith@ediscovery.com', 'RVW002'),
('Carol Davis', 'Team Alpha', 5, 'carol.davis@ediscovery.com', 'RVW003'),
('Daniel Brown', 'Team Alpha', 4, 'daniel.brown@ediscovery.com', 'RVW004'),
('Emma Wilson', 'Team Alpha', 7, 'emma.wilson@ediscovery.com', 'RVW005'),

('Frank Miller', 'Team Beta', 9, 'frank.miller@ediscovery.com', 'RVW006'),
('Grace Taylor', 'Team Beta', 6, 'grace.taylor@ediscovery.com', 'RVW007'),
('Henry Moore', 'Team Beta', 5, 'henry.moore@ediscovery.com', 'RVW008'),
('Isabella Thomas', 'Team Beta', 3, 'isabella.thomas@ediscovery.com', 'RVW009'),
('Jack Anderson', 'Team Beta', 7, 'jack.anderson@ediscovery.com', 'RVW010'),

('Karen White', 'Team Gamma', 10, 'karen.white@ediscovery.com', 'RVW011'),
('Liam Harris', 'Team Gamma', 8, 'liam.harris@ediscovery.com', 'RVW012'),
('Mia Martin', 'Team Gamma', 6, 'mia.martin@ediscovery.com', 'RVW013'),
('Noah Thompson', 'Team Gamma', 5, 'noah.thompson@ediscovery.com', 'RVW014'),
('Olivia Garcia', 'Team Gamma', 4, 'olivia.garcia@ediscovery.com', 'RVW015'),

('Peter Martinez', 'Team Delta', 9, 'peter.martinez@ediscovery.com', 'RVW016'),
('Queenie Robinson', 'Team Delta', 7, 'queenie.robinson@ediscovery.com', 'RVW017'),
('Ryan Clark', 'Team Delta', 6, 'ryan.clark@ediscovery.com', 'RVW018'),
('Sophia Rodriguez', 'Team Delta', 5, 'sophia.rodriguez@ediscovery.com', 'RVW019'),
('Thomas Lewis', 'Team Delta', 8, 'thomas.lewis@ediscovery.com', 'RVW020'),

('Uma Walker', 'Team Omega', 4, 'uma.walker@ediscovery.com', 'RVW021'),
('Victor Hall', 'Team Omega', 6, 'victor.hall@ediscovery.com', 'RVW022'),
('William Allen', 'Team Omega', 5, 'william.allen@ediscovery.com', 'RVW023'),
('Xavier Young', 'Team Omega', 7, 'xavier.young@ediscovery.com', 'RVW024'),
('Zoe King', 'Team Omega', 3, 'zoe.king@ediscovery.com', 'RVW025');

-- ============================================================
-- Seed Data: Uploads
-- Total Records: 500
-- One upload per custodian
-- ============================================================

INSERT INTO uploads (
    case_id,
    custodian_id,
    upload_date,
    data_size_gb,
    documents_uploaded,
    processing_time_minutes,
    processing_status
)
SELECT
    c.case_id,
    c.custodian_id,
    CURRENT_DATE - (FLOOR(random() * 180))::INTEGER,
    ROUND((5 + random() * 45)::NUMERIC, 2),
    (FLOOR(random() * 45000) + 5000)::INTEGER,
    (FLOOR(random() * 240) + 20)::INTEGER,
    CASE FLOOR(random() * 4)
        WHEN 0 THEN 'Completed'
        WHEN 1 THEN 'Processing'
        WHEN 2 THEN 'Pending'
        ELSE 'Failed'
    END
FROM custodians c;

-- Verification
SELECT COUNT(*) AS total_uploads
FROM uploads;

SELECT *
FROM uploads
ORDER BY upload_id
LIMIT 10;

-- ==========================================================
-- Seed Data: Reviews
-- Description: Generate one review for every upload
-- Total Records: 500
-- ==========================================================

INSERT INTO reviews (
    upload_id,
    reviewer_id,
    review_start,
    review_end,
    documents_reviewed,
    privileged_documents,
    qc_status,
    review_status
)
SELECT
    u.upload_id,
    (FLOOR(random() * 25) + 1)::INTEGER,
    u.upload_date + INTERVAL '1 day',
    u.upload_date + INTERVAL '3 days',
    (FLOOR(random() * u.documents_uploaded) + 1)::INTEGER,
    (FLOOR(random() * 100))::INTEGER,

    CASE (FLOOR(random() * 4))::INT
        WHEN 0 THEN 'Passed'
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Failed'
        ELSE 'Not Required'
    END,

    CASE (FLOOR(random() * 4))::INT
        WHEN 0 THEN 'Completed'
        WHEN 1 THEN 'In Progress'
        WHEN 2 THEN 'Pending'
        ELSE 'Escalated'
    END

FROM uploads u;
