-- =============================================================================
-- ADVANCED SQL 2 — FUNCTION: avg_fee_by_genre
-- Technique: user-defined FUNCTION · aggregate (AVG) · parameterised lookup
--
-- Business purpose:
--   Returns the average entertainer fee for a given genre, giving Cindy instant,
--   reusable pricing insight when quoting clients and benchmarking entertainers —
--   no repeated manual calculation.
-- =============================================================================

DROP FUNCTION IF EXISTS avg_fee_by_genre;

DELIMITER $$

CREATE FUNCTION avg_fee_by_genre(
    genre_input VARCHAR(50)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_fee DECIMAL(10,2);

    SELECT AVG(Normal_Fee)
    INTO avg_fee
    FROM Entertainer
    WHERE Genre = genre_input;

    RETURN avg_fee;
END$$

DELIMITER ;

-- Testing SQL2: FUNCTION
-- Step 1: View available genres
--   SELECT DISTINCT Genre FROM Entertainer;
-- Step 2: Call the function with a known genre
--   SELECT avg_fee_by_genre('Funk') AS Avg_Funk_Fee;
--   SELECT avg_fee_by_genre('Pop') AS Avg_Pop_Fee;
--   SELECT avg_fee_by_genre('HipHop') AS Avg_HipHop_Fee;
-- Step 3: Test with an unknown or unused genre (should return NULL)
--   SELECT avg_fee_by_genre('Aucostic') AS Avg_Aucostic_Fee;  -- If no entertainers in this genre
-- Step 4: Cross-check manually
--   SELECT Genre, AVG(Normal_Fee) AS Manual_Avg
--   FROM Entertainer
--   GROUP BY Genre
-- If the results match the function output, the function works as expected.
