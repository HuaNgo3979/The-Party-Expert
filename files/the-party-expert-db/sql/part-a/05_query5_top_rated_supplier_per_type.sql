-- =============================================================================
-- SQL 5 — Supplier Performance: Most-Rated Supplier Per Type
-- Techniques: subquery (derived table) · JOIN · scalar functions (UPPER, CONCAT)
--
-- Business purpose:
--   Surfaces the top-rated (5-star) supplier for each category so TPE can build a
--   preferred-vendor list, guarantee service quality and line up substitutes.
--   UPPER() and CONCAT() are used for presentation/readability of the output.
-- =============================================================================

SELECT
    filtered.S_Type,
    Supplier.Company_Name,
    Supplier.S_Email,
    Supplier.S_Phone,
    UPPER(Supplier.S_City)              AS City_UpperCase,
    CONCAT('Rating: ', Supplier.Rating) AS Full_Rating
FROM Supplier
JOIN (
    SELECT
        Purchase.S_Type,
        MAX(Supplier.Supplier_ID) AS Max_Supplier
    FROM Supplier
    JOIN Purchase
        ON Supplier.Supplier_ID = Purchase.Supplier_ID
    WHERE Supplier.Rating = 5
    GROUP BY Purchase.S_Type
) AS filtered
    ON Supplier.Supplier_ID = filtered.Max_Supplier
ORDER BY filtered.S_Type;
