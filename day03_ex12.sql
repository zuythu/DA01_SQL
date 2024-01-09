SELECT DISTINCT author_id FROM Views
WHERE viewer_id = author_id
AND viewr_id >=1
ORDER BY author_id
