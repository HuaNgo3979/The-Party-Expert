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

-- Test:
--   Should FAIL  -> UPDATE Employee SET Resigned_Date = '2025-06-05' WHERE Employee_ID = 10;  (has future party)
--   Should PASS  -> UPDATE Employee SET Resigned_Date = '2025-06-05' WHERE Employee_ID = 96;  (no future party)
