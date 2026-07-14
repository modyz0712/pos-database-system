/*
Format: Promotion_Transaction.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME :Koo Ian Hong
STUDENT ID :2205896
GROUP NUMBER : G036
PROGRAMME : CS
Submission date and time: 29-Apr-2025
*/

SET LINESIZE 150
SET PAGESIZE 50

/* Query 1： List Active Voucher Promotions*/

COLUMN promotionID FORMAT A10
COLUMN promotion_name FORMAT A30
COLUMN voucher_code FORMAT A20
COLUMN discount_value FORMAT 9990.00

SELECT p.promotionID, p.promotion_name, v.voucher_code, v.discount_value
FROM Promotion p
JOIN Voucher v ON p.promotionID = v.promotionID
WHERE p.promotion_type = 'Voucher'
AND SYSDATE BETWEEN p.StartDate AND p.ExpDate;


/* Query 2: List Promotions Used by Each Customer*/

COLUMN customerID FORMAT A10
COLUMN customer_name FORMAT A20
COLUMN promotion_name FORMAT A30
COLUMN redeem_Date FORMAT A20

SELECT c.customerID, c.name AS customer_name, p.promotion_name, pu.redeem_Date
FROM Customer c
JOIN Orders o ON c.customerID = o.customerID
JOIN Promotion_Used pu ON o.orderID = pu.orderID
JOIN Promotion p ON pu.promotionID = p.promotionID
ORDER BY c.customerID, pu.redeem_Date;


/* Stored Procedure 1: Insert Promotion Usage */
CREATE OR REPLACE PROCEDURE Insert_Promotion_Usage (
current_promotionID IN Promotion_Used.promotionID%TYPE,
current_orderID IN Promotion_Used.orderID%TYPE
) IS
BEGIN
INSERT INTO Promotion_Used(promotionID, orderID, redeem_Date, description)
VALUES (current_promotionID, current_orderID, SYSDATE, 'Promotion applied to order');

COMMIT;

DBMS_OUTPUT.PUT_LINE('Promotion usage recorded successfully.');

END;
/

EXEC Insert_Promotion_Usage('PR001', 'O003');


/* Stored Procedure 2: Delete Transaction */
CREATE OR REPLACE PROCEDURE Delete_Transaction (
current_thID IN Transaction_History.th_ID%TYPE
) IS
BEGIN
DELETE FROM Transaction_History
WHERE th_ID = current_thID;
    
IF SQL%ROWCOUNT > 0 THEN
DBMS_OUTPUT.PUT_LINE('Transaction ' || current_thID || ' deleted successfully.');

COMMIT;

ELSE
DBMS_OUTPUT.PUT_LINE('Transaction ID not found.');
END IF;

END;
/

EXECUTE Delete_Transaction('TH001');


/* Function 1: Count Promotions */
CREATE OR REPLACE FUNCTION Count_Promotions (
current_promotionType IN Promotion.promotion_type%TYPE DEFAULT NULL
) RETURN NUMBER IS
v_count NUMBER := 0;
BEGIN
SELECT COUNT(*)
INTO v_count
FROM Promotion
WHERE (current_promotionType IS NULL OR promotion_type = current_promotionType);

RETURN v_count;
END;
/

SELECT Count_Promotions(NULL) FROM DUAL;
SELECT Count_Promotions('Voucher') FROM DUAL;
SELECT Count_Promotions('Reward') FROM DUAL;


/* Function 2: Get the latest transaction date for a customer */
CREATE OR REPLACE FUNCTION get_latest_transaction_date(
p_customer_id IN Transaction_History.customerID%TYPE
) RETURN DATE IS
v_latest_date DATE;
BEGIN
SELECT MAX(th_timestamp)
INTO v_latest_date
FROM Transaction_History
WHERE customerID = p_customer_id;

RETURN v_latest_date;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;
/

SELECT get_latest_transaction_date('CU005') FROM DUAL;
SELECT get_latest_transaction_date('CU001') FROM DUAL;


