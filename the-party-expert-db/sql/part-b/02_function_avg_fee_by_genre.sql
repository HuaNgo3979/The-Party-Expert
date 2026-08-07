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

-- Test examples:
--   SELECT avg_fee_by_genre('Funk')  AS Avg_Funk_Fee;
--   SELECT avg_fee_by_genre('Pop')   AS Avg_Pop_Fee;
--   SELECT avg_fee_by_genre('HipHop') AS Avg_HipHop_Fee;
-- Cross-check:
--   SELECT Genre, AVG(Normal_Fee) AS Manual_Avg FROM Entertainer GROUP BY Genre;
