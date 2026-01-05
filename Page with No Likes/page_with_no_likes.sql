-- Using EXCEPT to find pages with no likes
SELECT
  page_id
FROM
  pages
EXCEPT
SELECT
  page_id
FROM
  page_likes
ORDER BY
  page_id;

-- Using LEFT JOIN to find pages with no likes
SELECT
  p.page_id
FROM
  pages p
LEFT OUTER JOIN
  page_likes pl
ON
  p.page_id = pl.page_id
WHERE
  pl.page_id IS NULL
ORDER by p.page_id;


-- Using NOT IN to find pages with no likes
SELECT page_id
FROM pages
WHERE page_id NOT IN (
  SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL
)
order by page_id;

-- Using NOT EXISTS to find pages with no likes
SELECT p.page_id
FROM
  pages p
WHERE
  NOT EXISTS (
    SELECT
      1 
    FROM
      page_likes pl
    WHERE
      p.page_id = pl.page_id
  )
ORDER BY
  p.page_id;
