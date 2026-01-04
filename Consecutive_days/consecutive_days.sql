-- SQL script to find users with at least 3 consecutive days of activity

-- Assuming a table named 'consecutive_table' with columns: id, activity_date, account_id, user_id
drop table if exists consecutive_table;

-- Create the table for demonstration purposes
create table if not exists consecutive_table (
    id int,
    activity_date date,
    account_id varchar,
    user_id varchar
);

-- Since the data we get has an 'id' column which is not needed for our analysis, we will drop it
alter table consecutive_table drop column id;

-- Checking the data
select * from consecutive_table limit 10;

-- Finding users with at least 3 consecutive days of activity
WITH ranked_events AS (             -- Step 1: Assign a group identifier to each sequence of consecutive days
    SELECT
        user_id,
        activity_date,
        activity_date - 
        cast(ROW_NUMBER() OVER (    -- Step 2: Calculate the difference between the date and the row number
            PARTITION BY user_id 
            ORDER BY activity_date
        ) AS int
            ) as streaks
    FROM consecutive_table
),
streaks AS (                        -- Step 3: Count the length of each streak for each user   
    SELECT
        user_id,
        COUNT(*) AS streak_length
    FROM ranked_events
    GROUP BY user_id, streaks
)
SELECT DISTINCT user_id             -- Step 4: Select users with streak length of at least 3
FROM streaks
WHERE streak_length >= 3;