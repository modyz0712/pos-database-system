/*
Format: Employee_Menu.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME :Chin Zheng Quan
STUDENT ID :2206396
GROUP NUMBER : G036
PROGRAMME : CS
Submission date and time: 29-Apr-2025

SQL script to be submtted by each member, click save as "G999_MemberName.sql" e.g. G001_SmithWhite.sql

*/



/* Query 1 */

SELECT o.employeeID ,o.orderID,e.salary
FROM Employee e , Orders o
WHERE o.employeeID=e.employeeID
ORDER BY salary;                                                                                                           


/* Query 2 */

SELECT o.orderID,p.paymentMethod ,s.service_type
FROM Orders o ,Payment p , Service s
WHERE o.orderID=p.orderID
AND o.serviceID=s.serviceID
AND service_type = INITCAP('delivery');

/* Stored procedure 1 */
CREATE OR REPLACE PROCEDURE update_Employee_Info(
current_employeeID IN VARCHAR2,
current_e_name IN VARCHAR2,
current_e_phone IN VARCHAR2,
current_ws IN VARCHAR2,
current_salary IN NUMBER)
IS
BEGIN
UPDATE Employee
SET e_name = current_e_name, e_phone = current_e_phone, working_slot = current_ws,salary=current_salary
WHERE employeeID = current_employeeID;

COMMIT;
END;
/

EXECUTE update_Employee_Info('E001','Kambing','012-3456789','Morning',3000.00);



/* Stored procedure 2 */
CREATE OR REPLACE PROCEDURE update_Menu_Info(
current_menuID IN VARCHAR2,
current_itemName IN VARCHAR2,
current_itemPrice IN NUMBER)
IS
BEGIN
UPDATE Menu
SET itemName = current_itemName, itemPrice = current_itemPrice
WHERE menuID = current_menuID;

COMMIT;
END;
/

EXECUTE update_Menu_Info('M002','Fry Chicken',5.00);


/* Function 1 */

CREATE OR REPLACE FUNCTION get_itemprice (
p_itemName IN VARCHAR2 )
RETURN NUMBER
IS
    result NUMBER(5,2);
BEGIN
    SELECT itemPrice
    INTO result
    FROM Menu
    WHERE UPPER(itemName) = UPPER(p_itemName); 

    RETURN result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END;
/

SELECT get_itemprice('Pizza') FROM dual;

/* Function 2 */
CREATE OR REPLACE FUNCTION addCustomPrice(
    p_itemName IN VARCHAR2,
    p_customName IN VARCHAR2
) RETURN NUMBER
IS
    result NUMBER(5,2);
BEGIN
    SELECT m.itemPrice + c.addPrice
    INTO result
    FROM Menu m, Customization c
    WHERE UPPER(m.itemName) = UPPER(p_itemName)
      AND UPPER(REPLACE（c.description,' ','_'))= UPPER(REPLACE(p_customName,' ','_'))
      AND m.menuID = c.menuID;

    RETURN result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

SELECT addCustomPrice('Pizza', 'Extra Cheese') FROM dual;