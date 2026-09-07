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

--complete case hierarchy---

UPDATE cases
SET parent_case_id = CASE case_id
    WHEN 25 THEN 5
    WHEN 45 THEN 5
    WHEN 65 THEN 5
    WHEN 85 THEN 5

    WHEN 26 THEN 6
    WHEN 46 THEN 6
    WHEN 66 THEN 6
    WHEN 86 THEN 6

    WHEN 27 THEN 7
    WHEN 47 THEN 7
    WHEN 67 THEN 7
    WHEN 87 THEN 7

    WHEN 28 THEN 8
    WHEN 48 THEN 8
    WHEN 68 THEN 8
    WHEN 88 THEN 8

    WHEN 29 THEN 9
    WHEN 49 THEN 9
    WHEN 69 THEN 9
    WHEN 89 THEN 9

    WHEN 30 THEN 10
    WHEN 50 THEN 10
    WHEN 70 THEN 10
    WHEN 90 THEN 10

    WHEN 31 THEN 11
    WHEN 51 THEN 11
    WHEN 71 THEN 11
    WHEN 91 THEN 11

    WHEN 32 THEN 12
    WHEN 52 THEN 12
    WHEN 72 THEN 12
    WHEN 92 THEN 12

    WHEN 33 THEN 13
    WHEN 53 THEN 13
    WHEN 73 THEN 13
    WHEN 93 THEN 13

    WHEN 34 THEN 14
    WHEN 54 THEN 14
    WHEN 74 THEN 14
    WHEN 94 THEN 14

    WHEN 35 THEN 15
    WHEN 55 THEN 15
    WHEN 75 THEN 15
    WHEN 95 THEN 15

    WHEN 36 THEN 16
    WHEN 56 THEN 16
    WHEN 76 THEN 16
    WHEN 96 THEN 16

    WHEN 37 THEN 17
    WHEN 57 THEN 17
    WHEN 77 THEN 17
    WHEN 97 THEN 17

    WHEN 38 THEN 18
    WHEN 58 THEN 18
    WHEN 78 THEN 18
    WHEN 98 THEN 18

    WHEN 39 THEN 19
    WHEN 59 THEN 19
    WHEN 79 THEN 19
    WHEN 99 THEN 19

    WHEN 40 THEN 20
    WHEN 60 THEN 20
    WHEN 80 THEN 20
    WHEN 100 THEN 20

    ELSE parent_case_id
END
WHERE case_id IN (
    25, 45, 65, 85,
    26, 46, 66, 86,
    27, 47, 67, 87,
    28, 48, 68, 88,
    29, 49, 69, 89,
    30, 50, 70, 90,
    31, 51, 71, 91,
    32, 52, 72, 92,
    33, 53, 73, 93,
    34, 54, 74, 94,
    35, 55, 75, 95,
    36, 56, 76, 96,
    37, 57, 77, 97,
    38, 58, 78, 98,
    39, 59, 79, 99,
    40, 60, 80, 100
);

--- Clean up correct top-level ---

UPDATE cases
SET parent_case_id = NULL
WHERE case_id IN (2, 3, 4);

--- Verify---
SELECT
    case_id,
    case_name,
    parent_case_id
FROM cases
WHERE case_id BETWEEN 1 AND 20
ORDER BY case_id;
