-- =============================================================================
-- ADVANCED SQL 4 — TRIGGER: prevent_future_resign
-- Technique: BEFORE UPDATE TRIGGER · EXISTS subquery · SIGNAL (custom error)
--
-- Business purpose:
--   A safeguard that blocks an employee from being marked as resigned while they
--   are still assigned to upcoming parties. Enforces workforce-availability rules,
--   prevents scheduling conflicts and protects service continuity.
-- =============================================================================

DROP TRIGGER IF EXISTS prevent_future_resign;

DELIMITER $$

CREATE TRIGGER prevent_future_resign
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Resigned_Date IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM Responsibility r
            JOIN Party p ON r.Party_ID = p.Party_ID
            WHERE r.Employee_ID = NEW.Employee_ID
              AND p.Party_Date  > '2024-06-01'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee has future party assignments and cannot resign yet.';
        END IF;
    END IF;
END$$

DELIMITER ;

-- Testing: TRIGGER
-- Step 1: View which employees are scheduled for future parties (after '2024-06-01')
-- SELECT DISTINCT r.Employee_ID, p.Party_Date
-- FROM Responsibility r
-- JOIN Party p ON r.Party_ID = p.Party_ID
-- WHERE p.Party_Date > '2024-06-01';
--
-- Step 2: Attempt to resign an employee with a future assignment (should FAIL)
-- SET SQL_SAFE_UPDATES = 0;
--
-- Step 3: Find a safe Employee_ID with NO future assignment (for testing success case)
-- SELECT e.Employee_ID
-- FROM Employee e
-- WHERE e.Employee_ID NOT IN (
--    SELECT DISTINCT r.Employee_ID
--    FROM Responsibility r
--    JOIN Party p ON r.Party_ID = p.Party_ID
--    WHERE p.Party_Date > '2024-06-01'
-- );
--
-- Step 4: Attempt to resign an employee with NO future assignment (should SUCCEED)
-- UPDATE Employee
-- SET Resigned_Date = '2025-06-05'
-- WHERE Employee_ID = 96;
--
-- Step 5: Verify outcomes
-- SELECT Employee_ID, Resigned_Date
-- FROM Employee
-- WHERE Employee_ID IN (10, 96);
-- SET SQL_SAFE_UPDATES = 1;
