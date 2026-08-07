-- =============================================================================
-- ADVANCED SQL 1 — VIEW: Party_Cost_Summary
-- Technique: VIEW · six-table JOIN · aggregation (COUNT DISTINCT, SUM)
--
-- Business purpose:
--   A single, reusable summary of every party — client, lead employee, support
--   headcount, total invoiced amount, venue and participants — so Cindy can
--   review each party at a glance, plan the workforce and refine pricing.
-- =============================================================================

DROP VIEW IF EXISTS Party_Cost_Summary;

CREATE VIEW Party_Cost_Summary AS
SELECT
    p.Party_ID,
    CONCAT(c.C_Given, ' ', c.C_Surname) AS Client_Name,
    CONCAT(e.M_Given, ' ', e.M_Surname) AS Lead_Employee,
    COUNT(DISTINCT r.Employee_ID)       AS Support_Staff_Count,
    SUM(i.Amount)                       AS Total_Invoice_Amount,
    l.L_Name                            AS Location_Name,
    p.No_Participant
FROM Party p
JOIN Client         c ON p.Client_ID        = c.Client_ID
JOIN Responsibility r ON p.Party_ID         = r.Party_ID
JOIN Employee       e ON p.Lead_Employee_ID = e.Employee_ID
JOIN Invoice        i ON p.Party_ID         = i.Party_ID
JOIN Location       l ON p.Location_ID       = l.Location_ID
GROUP BY
    p.Party_ID,
    c.C_Given, c.C_Surname,
    e.M_Given, e.M_Surname,
    l.L_Name,
    p.No_Participant
ORDER BY No_Participant DESC;

-- Test:
SELECT * FROM Party_Cost_Summary;
