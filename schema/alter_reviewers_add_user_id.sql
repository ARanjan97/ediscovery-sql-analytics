-- Step 1: Add the new column
ALTER TABLE reviewers
ADD COLUMN user_id VARCHAR(20);

-- Step 2: Populate existing reviewers
UPDATE reviewers
SET user_id = 'RVW' || LPAD(reviewer_id::TEXT, 3, '0')
WHERE user_id IS NULL;
