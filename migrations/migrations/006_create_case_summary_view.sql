---case summary---

CREATE VIEW vw_case_summary AS

WITH upload_summary AS (
    SELECT
        case_id,
        COUNT(upload_id) AS total_uploads,
        SUM(documents_uploaded) AS total_documents_uploaded
    FROM uploads
    GROUP BY case_id
),
review_summary AS (
    SELECT
        u.case_id,
        SUM(r.documents_reviewed) AS total_documents_reviewed
    FROM reviews r
    INNER JOIN uploads u
        ON r.upload_id = u.upload_id
    GROUP BY u.case_id
)
SELECT
    c.case_id,
    c.case_name,
    cl.client_name,
    COALESCE(us.total_uploads, 0) AS total_uploads,
    COALESCE(us.total_documents_uploaded, 0) AS total_documents_uploaded,
    COALESCE(rs.total_documents_reviewed, 0) AS total_documents_reviewed,
    ROUND(
        COALESCE(rs.total_documents_reviewed, 0) * 100.0
        / NULLIF(COALESCE(us.total_documents_uploaded, 0), 0),
        2
    ) AS review_completion_percentage
FROM cases c
INNER JOIN clients cl
    ON c.client_id = cl.client_id
LEFT JOIN upload_summary us
    ON c.case_id = us.case_id
LEFT JOIN review_summary rs
    ON c.case_id = rs.case_id;
