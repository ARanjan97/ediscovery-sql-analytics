-----Sla Tracking view----
CREATE VIEW vw_sla_performance AS
SELECT
    c.case_id,
    c.case_name,
    cl.client_id,
    cl.client_name,
    COUNT(s.sla_id) AS total_sla_records,
    COUNT(*) FILTER (WHERE s.sla_status = 'Met') AS sla_met,
    COUNT(*) FILTER (WHERE s.sla_status = 'Breached') AS sla_breached,
    COUNT(*) FILTER (WHERE s.sla_status = 'In Progress') AS sla_in_progress,
    ROUND(AVG(s.turnaround_hours), 2) AS avg_turnaround_hours,
    MIN(s.turnaround_hours) AS fastest_turnaround_hours,
    MAX(s.turnaround_hours) AS slowest_turnaround_hours,
    ROUND(
        COUNT(*) FILTER (WHERE s.sla_status = 'Met') * 100.0
        / NULLIF(COUNT(*) FILTER (WHERE s.sla_status IN ('Met', 'Breached')), 0),
        2
    ) AS sla_compliance_percentage
FROM cases c
INNER JOIN clients cl
    ON c.client_id = cl.client_id
LEFT JOIN sla_tracking s
    ON c.case_id = s.case_id
GROUP BY
    c.case_id,
    c.case_name,
    cl.client_id,
    cl.client_name;
