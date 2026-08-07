-- =============================================================================
-- SQL 4 — Party Scalability & Location: Large-Scale Party Location
-- Techniques: JOIN · scalar subquery (AVG) · WHERE filter · ORDER BY
--
-- Business purpose:
--   Identifies larger-than-average Melbourne parties and the venues that host
--   them, so TPE can plan logistics, negotiate with suppliers and allocate staff
--   for high-demand events. Venue contact details are returned for follow-up.
-- =============================================================================

SELECT
    Party.Party_ID,
    Location.L_Name,
    Party.Theme,
    Party.Party_Date,
    Location.L_City,
    Location.L_Suburb,
    Party.No_Participant,
    Location.L_Phone,
    Location.L_Email,
    Location.Manager_Name
FROM Party
JOIN Location
    ON Party.Location_ID = Location.Location_ID
WHERE
    Location.L_City = 'Melbourne'
    AND Party.No_Participant > (SELECT AVG(No_Participant) FROM Party)
ORDER BY Party.No_Participant DESC;
