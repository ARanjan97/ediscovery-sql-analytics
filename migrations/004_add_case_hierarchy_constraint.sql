ALTER TABLE cases
ADD CONSTRAINT fk_cases_parent
FOREIGN KEY (parent_case_id)
REFERENCES cases(case_id);
------------
Verification
-------------
SELECT
    case_id,
    case_name,
    parent_case_id
FROM cases
ORDER BY case_id;
