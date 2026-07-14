/*
Format: Payment_Receipt_Service.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME :Lai Keen Seng
STUDENT ID :2203300
GROUP NUMBER : G036
PROGRAMME : CS
Submission date and time: 29-Apr-2025
*/



/* Query 1 */

SELECT e_name AS name, s.service_type
FROM employee e, orders o, service s
WHERE e.employeeID = o.employeeID
and o.serviceID = s.serviceID
ORDER BY s.service_type, e_name;

/* Query 2 */

SELECT name, service_type
FROM customer c, orders o, service s
WHERE c.customerID = o.customerID
and o.serviceID = s.serviceID;

/* Stored procedure 1 */

CREATE OR REPLACE PROCEDURE update_Payment_Info(
current_paymentID IN VARCHAR2,
current_paymentAmount IN NUMBER,
current_paymentTimestamp IN DATE,
current_paymentMethod IN VARCHAR2,
current_orderID IN VARCHAR2)
IS
BEGIN
     UPDATE Payment
     SET paymentAmount = current_paymentAmount,
            paymentTimestamp = current_paymentTimestamp,
            paymentMethod = current_paymentMethod
      WHERE paymentID = current_paymentID
      AND orderID = current_orderID;
      COMMIT;
END;
/

Execute update_Payment_Info('P003',40, TO_DATE('2025-04-03','YYYY-MM-DD'),'Credit','O003');

/* Stored procedure 2 */

CREATE OR REPLACE PROCEDURE update_Receipt_Info(
current_receiptID IN VARCHAR2,
current_receiptTimestamp IN DATE,
current_receiptDetail IN VARCHAR2,
current_paymentID IN VARCHAR2)
IS
BEGIN
     UPDATE Receipt
     SET receiptTimestamp = current_receiptTimestamp,
            receiptDetail = current_receiptDetail
     WHERE receiptID = current_receiptID
     AND paymentID = current_paymentID;
     COMMIT;
END;
/

Execute update_Receipt_Info('R001', TO_DATE('2025-04-03','YYYY-MM-DD'),'Receipt 5','P001');

/* Function 1 */

CREATE OR REPLACE FUNCTION sum_delivery_fee
RETURN NUMBER
IS
    total_delivery_fee NUMBER(7,2);
BEGIN
    SELECT sum(delivery_fee)
    INTO total_delivery_fee
    FROM Delivery d, Service s, Orders o
    WHERE d.serviceID = s.serviceID
    AND s.serviceID = o.serviceID;

    
    IF total_delivery_fee IS NULL THEN
        RETURN 0;
    ELSE
        RETURN total_delivery_fee;
    END IF;
END;
/

SELECT sum_delivery_fee() AS total_delivery_fees
FROM dual;

/* Function 2 */

CREATE OR REPLACE FUNCTION count_successful_transactions
RETURN NUMBER
IS
    total_successful NUMBER(10);
BEGIN
    SELECT COUNT(*)
    INTO total_successful
    FROM Transaction_History
    WHERE transaction_status = 'SUCCESS';
    
    RETURN total_successful;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/


SELECT count_successful_transactions() AS successful_transaction_count
FROM dual;