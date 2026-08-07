-- =============================================================================
-- ADVANCED SQL 5 — NESTED QUERY: Top-rated Supplier Type Per Party
-- Technique: Common Table Expressions (WITH) · nested/derived subqueries · JOIN
--
-- Business purpose:
--   Ranks the highest-rated supplier type for each party, giving Cindy a clear,
--   data-driven view of best-performing vendors to support procurement decisions,
--   internal reviews and client negotiations.
-- =============================================================================

WITH SupplierAverages AS (
    SELECT
        pu.Party_ID,
        pu.S_Type,
        pu.Supplier_ID,
        AVG(su.Rating) AS AVG_Rating
    FROM Purchase pu
    JOIN Supplier su ON pu.Supplier_ID = su.Supplier_ID
    GROUP BY pu.Party_ID, pu.S_Type, pu.Supplier_ID
),
MaxRatings AS (
    SELECT Party_ID, MAX(AVG_Rating) AS Max_Rating
    FROM SupplierAverages
    GROUP BY Party_ID
),
Filtered AS (
    SELECT sa.*
    FROM SupplierAverages sa
    JOIN MaxRatings mr
        ON sa.Party_ID = mr.Party_ID
       AND sa.AVG_Rating = mr.Max_Rating
)
SELECT DISTINCT
    f.Party_ID,
    p.Theme AS Party_Theme,
    f.S_Type,
    f.AVG_Rating,
    s.Company_Name,
    s.Contact_Name,
    s.S_Email,
    s.S_Phone
FROM Filtered f
JOIN Supplier s ON f.Supplier_ID = s.Supplier_ID
JOIN Party    p ON f.Party_ID    = p.Party_ID
ORDER BY f.AVG_Rating DESC
LIMIT 10;
