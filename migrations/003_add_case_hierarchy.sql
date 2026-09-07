ALTER TABLE cases
ADD COLUMN parent_case_id INTEGER;

-----parent-child case relationships----

UPDATE cases
SET parent_case_id = CASE case_id
    WHEN 21 THEN 1
    WHEN 41 THEN 1
    WHEN 61 THEN 1
    WHEN 81 THEN 1
    WHEN 22 THEN 2
    WHEN 42 THEN 2
    WHEN 62 THEN 2
    WHEN 82 THEN 2
    WHEN 23 THEN 3
    WHEN 43 THEN 3
    WHEN 63 THEN 3
    WHEN 83 THEN 3
    WHEN 24 THEN 4
    WHEN 44 THEN 4
    WHEN 64 THEN 4
    WHEN 84 THEN 4
    ELSE parent_case_id
END
WHERE case_id IN (
    21, 41, 61, 81,
    22, 42, 62, 82,
    23, 43, 63, 83,
    24, 44, 64, 84
);
