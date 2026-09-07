CREATE VIEW public.vw_reviewer_performance AS

WITH reviewer_totals AS (
    SELECT
        rv.reviewer_id,
        rv.reviewer_name,
        COUNT(r.review_id) AS total_reviews,
        COALESCE(SUM(r.documents_reviewed), 0) AS total_documents_reviewed,
        COALESCE(ROUND(AVG(r.documents_reviewed), 2), 0) AS avg_documents_per_review
    FROM reviewers rv
    LEFT JOIN reviews r
        ON rv.reviewer_id = r.reviewer_id
    GROUP BY
        rv.reviewer_id,
        rv.reviewer_name
)
SELECT
    reviewer_id,
    reviewer_name,
    total_reviews,
    total_documents_reviewed,
    avg_documents_per_review,
    RANK() OVER (
        ORDER BY total_documents_reviewed DESC
    ) AS reviewer_rank,
    ROUND(
        total_documents_reviewed * 100.0
        / NULLIF(
            SUM(total_documents_reviewed) OVER (),
            0
        ),
        2
    ) AS workload_percentage,
    CASE
        WHEN total_documents_reviewed >= 50000 THEN 'High Performer'
        WHEN total_documents_reviewed >= 25000 THEN 'Medium Performer'
        ELSE 'Developing'
    END AS performance_category
FROM reviewer_totals;
