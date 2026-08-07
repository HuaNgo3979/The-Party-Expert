-- =============================================================================
-- SQL 1 — Employee Performance: Total Worked Hours Per Employee
-- Techniques: JOIN · GROUP BY · SUM · ORDER BY
--
-- Business purpose:
--   TPE has no measurable way to track staff effort per party. This query
--   totals each employee's worked hours by role, so management can identify
--   top performers, justify bonuses, and allocate shifts fairly.
-- =============================================================================

SELECT
    Employee.M_Given,
    Employee.M_Surname,
    Responsibility.Responsibility,
    SUM(Responsibility.Hours_Worked) AS Total_Hours
FROM Responsibility
JOIN Employee
    ON Responsibility.Employee_ID = Employee.Employee_ID
GROUP BY
    Employee.Employee_ID,
    Employee.M_Given,
    Employee.M_Surname,
    Responsibility.Responsibility
ORDER BY Total_Hours DESC;
