-- =============================================================================
-- SQL 2 — Client Management: Total Spending Per Client
-- Techniques: multi-table JOIN · GROUP BY · SUM · ORDER BY
--
-- Business purpose:
--   Track customer lifetime value (impossible on manual spreadsheets). High-value
--   clients can be targeted with loyalty offers and early-bird discounts, and
--   their profiles reused to retarget similar clients during the Sydney expansion.
-- =============================================================================

SELECT
    Client.C_Given,
    Client.C_Surname,
    Client.C_Phone,
    Client.C_Email,
    Client.Registered_Date,
    SUM(Invoice.Amount) AS Spending
FROM Invoice
JOIN Party
    ON Invoice.Party_ID = Party.Party_ID
JOIN Client
    ON Party.Client_ID = Client.Client_ID
GROUP BY
    Client.Client_ID,
    Client.C_Phone,
    Client.C_Email
ORDER BY Spending DESC;
