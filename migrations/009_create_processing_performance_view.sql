----Processing Performance---
CREATE VIEW vw_processing_performance AS
SELECT
    c.case_id,
    c.case_name,
    cl.client_id,
    cl.client_name,
    COUNT(u.upload_id) AS total_uploads,
    ROUND(COALESCE(SUM(u.data_size_gb), 0), 2) AS total_data_size_gb,
    COALESCE(SUM(u.documents_uploaded), 0) AS total_documents_uploaded,
    ROUND(AVG(u.processing_time_minutes), 2) AS avg_processing_time_minutes,
    COUNT(*) FILTER (WHERE u.processing_status = 'Completed') AS completed_uploads,
    COUNT(*) FILTER (WHERE u.processing_status = 'Failed') AS failed_uploads,
    COUNT(*) FILTER (WHERE u.processing_status = 'Processing') AS processing_uploads,
    COUNT(*) FILTER (WHERE u.processing_status = 'Pending') AS pending_uploads,
    ROUND(
        COUNT(*) FILTER (WHERE u.processing_status = 'Completed') * 100.0
        / NULLIF(COUNT(*) FILTER (WHERE u.processing_status IN ('Completed', 'Failed')), 0),
        2
    ) AS processing_success_percentage
FROM cases c
INNER JOIN clients cl
    ON c.client_id = cl.client_id
LEFT JOIN uploads u
    ON c.case_id = u.case_id
GROUP BY
    c.case_id,
    c.case_name,
    cl.client_id,
    cl.client_name;
