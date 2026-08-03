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
    CASE gs
        WHEN 1 THEN 'Patent Litigation'
        WHEN 2 THEN 'Employment Investigation'
        WHEN 3 THEN 'GDPR Compliance Review'
        WHEN 4 THEN 'Internal Audit'
        WHEN 5 THEN 'Contract Dispute'
    END,

    (ARRAY['Active','Closed','On Hold'])[floor(random()*3 + 1)],

    (ARRAY['High','Medium','Low'])[floor(random()*3 + 1)],

    CURRENT_DATE - (floor(random()*365))::INTEGER,

    NULL

FROM clients c
CROSS JOIN generate_series(1,5) AS gs;
