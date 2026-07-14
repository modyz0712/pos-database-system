/*
Format: Customer_Membership_Feedback.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : Lim Yi Xiang
STUDENT ID : 2204852
GROUP NUMBER : G036
PROGRAMME : CS
Submission date and time: 29-04-2025

*/

/* Query 1 */

-- Set the column width for better view
SET LINESIZE 200
COLUMN "Customer's name" FORMAT A20
COLUMN rating FORMAT 99
COLUMN "Comment" FORMAT A50 

SELECT name AS "Customer's name", rating, f_comment AS "Comment"
FROM Feedback f, Customer c
WHERE c.customerID = f.customerID
ORDER BY rating DESC;


/* Query 2 */
SET LINESIZE 200
COLUMN "Customer's name" FORMAT A20
COLUMN email FORMAT A30
COLUMN membershipID FORMAT A15
COLUMN membership_type FORMAT A10
COLUMN joinDate FORMAT A15

SELECT name AS "Customer's name", email, membershipID, membership_type, joinDate
FROM Customer c, Membership m
WHERE c.customerID = m.customerID
ORDER BY 
	CASE m.membership_type
        WHEN 'bronze' THEN 1
        WHEN 'silver' THEN 2
        WHEN 'gold' THEN 3
    END,
    c.name;

/* Query 3 */
SELECT c.customerID, c.name AS customer_name, th.th_ID AS transaction_id,
    th.th_timestamp AS transaction_time, th.transaction_status,
    p.paymentID, p.paymentAmount, p.paymentMethod
FROM Customer c, Transaction_history th, payment p
WHERE c.customerID = th.customerID
AND th.paymentID = p.paymentID
AND c.customerID = 'CU001'
ORDER BY th.th_timestamp;


/* Stored procedure 1 */

CREATE OR REPLACE PROCEDURE update_Customer_Info(
current_customerID IN VARCHAR2,
current_name IN VARCHAR2,
current_phoneNo IN VARCHAR2,
current_email IN VARCHAR2) IS
BEGIN
	UPDATE Customer
	SET name = current_name, phoneNo = current_phoneNo, email = current_email
	WHERE customerID = current_customerID;
	COMMIT;
END;
/

EXECUTE update_Customer_Info('CU001','Lim Yi Xiang','0162225555','yixiang123@email.com');

SELECT *
FROM Customer;

/* Stored procedure 2 */

CREATE OR REPLACE PROCEDURE update_Membership_Info(
current_membershipID IN VARCHAR2,
current_joinDate IN DATE,
current_membership_type IN VARCHAR2,
current_discountPercentage IN NUMBER,
current_customerID IN VARCHAR2) IS
BEGIN
	UPDATE Membership
	SET membership_type = current_membership_type,
		discountPercentage = current_discountPercentage,
		joinDate = current_joinDate
	WHERE membershipID = current_membershipID
	AND customerID = current_customerID;
	COMMIT;
END;
/

Execute update_Membership_Info('MB002', TO_DATE('2025-04-02', 'YYYY-MM-DD'), 'gold', 0.15, 'CU002');

SELECT *
FROM MEMBERSHIP;

/* Function 1 */

CREATE OR REPLACE FUNCTION generate_receipt_content(p_orderID IN VARCHAR2)
RETURN VARCHAR2
IS
	v_receipt VARCHAR2(1000);
	v_orderDate VARCHAR2(20);
	v_totalAmount VARCHAR2(20);
	v_finalAmount VARCHAR2(20);
	v_discountAmount VARCHAR2(20);
	v_paymentAmount VARCHAR2(20);
	v_paymentMethod VARCHAR2(20);
	v_orderItemDetails VARCHAR2(3000);

BEGIN
	SELECT TO_CHAR(orderDate, 'YYYY-MM-DD'), 
		TO_CHAR(totalAmount), 
		TO_CHAR(finalAmount), 
		TO_CHAR(discountAmount)
	INTO v_orderDate, v_totalAmount, v_finalAmount, v_discountAmount
	FROM Orders
	WHERE orderID = p_orderID;
    
	SELECT TO_CHAR(paymentAmount), paymentMethod
	INTO v_paymentAmount, v_paymentMethod
	FROM Payment
	WHERE orderID = p_orderID;

	v_orderItemDetails := '';
    	FOR rec IN (
        SELECT oi.menuID, m.itemName, oi.quantity, oi.subtotal
        FROM OrderItem oi
        JOIN Menu m ON oi.menuID = m.menuID
        WHERE oi.orderID = p_orderID
    	) LOOP
        v_orderItemDetails := v_orderItemDetails ||
                              'Item: ' || rec.itemName || ' (ID: ' || rec.menuID || ')' || CHR(10) ||
                              'Quantity: ' || rec.quantity || CHR(10) ||
                              'Subtotal: RM' || rec.subtotal || CHR(10) ||
                              '---------------------------' || CHR(10);
    	END LOOP;

    	v_receipt := '=== Receipt ===' || CHR(10) ||
                 	'Order ID: ' || p_orderID || CHR(10) ||
                 	'Order Date: ' || v_orderDate || CHR(10) ||
                 	'Total Amount: RM' || v_totalAmount || CHR(10) ||
                 	'Discount: RM' || v_discountAmount || CHR(10) ||
                 	'Final Amount: RM' || v_finalAmount || CHR(10) ||
                 	'Payment Method: ' || v_paymentMethod || CHR(10) ||
                 	'Amount Paid: RM' || v_paymentAmount || CHR(10) ||
                 	'---------------------------' || CHR(10) ||
                 	'Order Items: ' || CHR(10) ||
                 	v_orderItemDetails;

	RETURN v_receipt;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Payment not found.';
END;
/


SELECT generate_receipt_content('O001') FROM dual;

/* Function 2 */

CREATE OR REPLACE FUNCTION average_rating 
RETURN NUMBER
IS
    avg_rating NUMBER(3,2);
BEGIN
    SELECT AVG(rating)
    INTO avg_rating
    FROM Feedback;
    
    IF avg_rating IS NULL THEN
        RETURN 0;
    ELSE
        RETURN avg_rating;
    END IF;
END;
/

SELECT average_rating
FROM dual;


