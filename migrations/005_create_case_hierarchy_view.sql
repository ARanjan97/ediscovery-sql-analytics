---Create View---
CREATE VIEW vw_case_hierarchy AS
WITH RECURSIVE case_hierarchy AS (
    SELECT
        case_id,
        case_name,
        parent_case_id,
        0 AS hierarchy_level
    FROM cases
    WHERE parent_case_id IS NULL

    UNION ALL

    SELECT
        c.case_id,
        c.case_name,
        c.parent_case_id,
        ch.hierarchy_level + 1
    FROM cases c
    INNER JOIN case_hierarchy ch
        ON c.parent_case_id = ch.case_id
)
SELECT
    case_id,
    case_name,
    parent_case_id,
    hierarchy_level
FROM case_hierarchy;
