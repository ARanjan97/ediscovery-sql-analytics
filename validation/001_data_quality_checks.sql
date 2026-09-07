----Check for orphaned uploads---
SELECT
    u.upload_id,
    u.case_id
FROM uploads u
LEFT JOIN cases c
    ON u.case_id = c.case_id
WHERE c.case_id IS NULL;


----Check for orphaned reviews---
SELECT
    r.review_id,
    r.upload_id,
    r.reviewer_id
FROM reviews r
LEFT JOIN uploads u
    ON r.upload_id = u.upload_id
LEFT JOIN reviewers rv
    ON r.reviewer_id = rv.reviewer_id
WHERE u.upload_id IS NULL
   OR rv.reviewer_id IS NULL;

----Check important NULLs---
SELECT
    COUNT(*) FILTER (WHERE case_id IS NULL) AS missing_case_id,
    COUNT(*) FILTER (WHERE custodian_id IS NULL) AS missing_custodian_id,
    COUNT(*) FILTER (WHERE documents_uploaded IS NULL) AS missing_documents,
    COUNT(*) FILTER (WHERE processing_status IS NULL) AS missing_processing_status
FROM uploads;

----Check impossible numeric values---
SELECT *
FROM uploads
WHERE data_size_gb < 0
   OR documents_uploaded < 0
   OR processing_time_minutes < 0;

----Check duplicate IDs----
SELECT
    upload_id,
    COUNT(*) AS duplicate_count
FROM uploads
GROUP BY upload_id
HAVING COUNT(*) > 1;

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;


----Freeze the Reporting Layer----
SELECT
    table_name
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name IN (
      'vw_case_hierarchy',
      'vw_case_summary',
      'vw_reviewer_performance',
      'vw_sla_performance',
      'vw_processing_performance'
  )
ORDER BY table_name;

SELECT 'vw_case_hierarchy' AS view_name, COUNT(*) AS row_count FROM vw_case_hierarchy
UNION ALL
SELECT 'vw_case_summary', COUNT(*) FROM vw_case_summary
UNION ALL
SELECT 'vw_reviewer_performance', COUNT(*) FROM vw_reviewer_performance
UNION ALL
SELECT 'vw_sla_performance', COUNT(*) FROM vw_sla_performance
UNION ALL
SELECT 'vw_processing_performance', COUNT(*) FROM vw_processing_performance;
