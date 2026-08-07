-- =============================================================================
-- SQL 3 — Billing Transparency: Overdue Final Invoice Update  (ACTION QUERY)
-- Techniques: UPDATE across joined tables · date arithmetic · conditional filter
--
-- Business purpose:
--   Automates detection of overdue FINAL invoices so TPE can chase payments and
--   improve its record-to-report process. Only final invoices still 'Pending'
--   more than 14 days after the party are flagged 'Overdue'; deposits are left as is.
--
-- Note: SQL_SAFE_UPDATES is toggled because this multi-join UPDATE does not target
--       an indexed key column directly.
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE Invoice AS i
JOIN Party  AS p ON i.Party_ID  = p.Party_ID
JOIN Client AS c ON p.Client_ID = c.Client_ID
SET i.Payment_Status = 'Overdue'
WHERE
    i.Invoice_Type   = 'Final'
    AND i.Payment_Status = 'Pending'
    AND i.Invoice_Date > DATE_ADD(p.Party_Date, INTERVAL 14 DAY);

SET SQL_SAFE_UPDATES = 1;
