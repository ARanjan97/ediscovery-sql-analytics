---Divinding the reviewer based on performance---

CREATE OR REPLACE VIEW vw_reviewer_performance AS
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
),
ranked_reviewers AS (
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
            / NULLIF(SUM(total_documents_reviewed) OVER (), 0),
            2
        ) AS workload_percentage,
        NTILE(4) OVER (
            ORDER BY total_documents_reviewed DESC
        ) AS performance_quartile
    FROM reviewer_totals
)
SELECT
    reviewer_id,
    reviewer_name,
    total_reviews,
    total_documents_reviewed,
    avg_documents_per_review,
    reviewer_rank,
    workload_percentage,
    CASE
        WHEN performance_quartile = 1 THEN 'Top Performer'
        WHEN performance_quartile = 2 THEN 'Strong Performer'
        WHEN performance_quartile = 3 THEN 'Core Performer'
        ELSE 'Developing'
    END AS performance_category
FROM ranked_reviewers;
