-- =============================================================================
-- ADVANCED SQL 3 — PROCEDURE: insert_invoice_with_validation
-- Technique: stored PROCEDURE · input parameters · validation · SIGNAL (custom error)
--
-- Business purpose:
--   Inserts a new invoice only when the amount is valid (> 0), rejecting bad data
--   with a clear error. This protects billing integrity as TPE moves off manual
--   spreadsheets, letting staff add invoices with confidence.
-- =============================================================================

DROP PROCEDURE IF EXISTS insert_invoice_with_validation;

DELIMITER $$

CREATE PROCEDURE insert_invoice_with_validation (
    IN p_party_id       INT,
    IN p_invoice_type   VARCHAR(50),
    IN p_amount         DECIMAL(10,2),
    IN p_invoice_date   DATE,
    IN p_payment_status VARCHAR(50),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invoice amount must be greater than zero';
    ELSE
        INSERT INTO Invoice (Party_ID, Invoice_Type, Amount, Invoice_Date, Payment_Status, Payment_Method)
        VALUES (p_party_id, p_invoice_type, p_amount, p_invoice_date, p_payment_status, p_payment_method);
    END IF;
END $$

DELIMITER ;

-- Testing SQL3: PROCEDURE
-- Step 1: Call the procedure with a VALID amount (should succeed)
-- CALL insert_invoice_with_validation(
--    5184,               -- Party_ID
--    'Final',            -- Invoice_Type
--    9500.00,            -- Amount (valid)
--    '2025-06-15',       -- Invoice_Date
--    'Pending',          -- Payment_Status
--    'Card'              -- Payment_Method
-- );
--
-- Step 2: Check the inserted invoice (only the valid one should appear)
-- SELECT * FROM Invoice
-- WHERE Party_ID = 5184
-- ORDER BY Invoice_Date DESC;
--
-- Step 3: Try another valid test with a different amount
-- CALL insert_invoice_with_validation(
--    5184,
--    'Final',
--    12345.67,
--    '2025-06-20',
--    'Paid',
--    'PayPal'
-- );
--
-- Step 4: Call the procedure with an INVALID amount (should error)
-- CALL insert_invoice_with_validation(
--    5184,
--    'Deposit',
--    -200.00,             -- Invalid amount
--    '2025-06-10',
--    'Pending',
--    'Bank Transfer'
-- );
