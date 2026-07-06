/*
COURSE CODE: UCCD2303
PROGRAMME (IA/IB/CS/DE: CS)
GROUP NUMBER e.g. G001: G036
GROUP LEADER NAME & EMAIL: Lim Yi Xiang yixiang0405@1utar.my
MEMBER 2 NAME: Chin Zheng Quan
MEMBER 3 NAME: Koo Ian Hong
MEMBER 4 NAME: Lai Keen Seng
Submission date and time (DD-MON-YY): 29-04-2025

*/



DROP TABLE Transaction_History CASCADE CONSTRAINTS;
DROP TABLE OrderItem CASCADE CONSTRAINTS;
DROP TABLE Customization CASCADE CONSTRAINTS;
DROP TABLE Feedback CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Receipt CASCADE CONSTRAINTS;
DROP TABLE Promotion_Used CASCADE CONSTRAINTS;
DROP TABLE Membership CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Voucher CASCADE CONSTRAINTS;
DROP TABLE Reward CASCADE CONSTRAINTS;
DROP TABLE Promotion CASCADE CONSTRAINTS;
DROP TABLE Table_Service CASCADE CONSTRAINTS;
DROP TABLE Delivery CASCADE CONSTRAINTS;
DROP TABLE Service CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Menu CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;


CREATE TABLE Menu (
menuID VARCHAR2(4) PRIMARY KEY,
itemName VARCHAR2(30),
itemPrice NUMBER(4,2) DEFAULT 0);

CREATE TABLE Customization (
customizationID VARCHAR2(4) PRIMARY KEY,
description VARCHAR2(100) NOT NULL,
addPrice NUMBER(5, 2) DEFAULT 0,
menuID VARCHAR2(4),
CONSTRAINT FK_Customization_Menu FOREIGN KEY (menuID) REFERENCES Menu(menuID));

CREATE TABLE Customer (
customerID VARCHAR2(5) PRIMARY KEY,
name VARCHAR2(20) NOT NULL,
phoneNo VARCHAR2(10) UNIQUE ,
email VARCHAR2(20) UNIQUE NOT NULL);

CREATE TABLE Employee (
employeeID VARCHAR2(4) PRIMARY KEY,
e_name VARCHAR2(15),
e_phone VARCHAR2(12),
working_slot VARCHAR2(10),
salary NUMBER(7,2) CHECK (salary > 0)
);

CREATE TABLE Feedback (
feedbackID VARCHAR2(4) PRIMARY KEY,
rating NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
f_comment VARCHAR2(150),
customerID VARCHAR2(5),
CONSTRAINT Feedback_customerID_fk FOREIGN KEY (customerID) REFERENCES Customer(customerID));

CREATE TABLE Service (
serviceID VARCHAR2(4) PRIMARY KEY,
service_type VARCHAR2(20) CHECK (service_type IN ('Table_Service','Delivery')) NOT NULL
);

CREATE TABLE Table_Service (
serviceID VARCHAR2(4) PRIMARY KEY,
table_No VARCHAR2(3) NOT NULL,
CONSTRAINT Table_Service_serviceID_fk FOREIGN KEY (serviceID) REFERENCES Service(serviceID)
);

CREATE TABLE Delivery (
serviceID VARCHAR2(4) PRIMARY KEY,
delivery_fee NUMBER(5,2),
address VARCHAR2(100) NOT NULL,
CONSTRAINT Delivery_serviceID_fk FOREIGN KEY (serviceID) REFERENCES Service(serviceID)
);

CREATE TABLE Orders (
orderID VARCHAR2(4) PRIMARY KEY,
orderDate DATE NOT NULL,
totalAmount NUMBER(6,2) CHECK (totalAmount>0),
finalAmount NUMBER(6,2) CHECK (finalAmount>0),
discountAmount NUMBER(6,2) CHECK (discountAmount>0),
employeeID VARCHAR2(4),
serviceID VARCHAR2(4),
customerID VARCHAR2(5),
CONSTRAINT Orders_employeeID_fk FOREIGN KEY (employeeID) REFERENCES Employee(employeeID),
CONSTRAINT Orders_serviceID_fk FOREIGN KEY (serviceID) REFERENCES Service(serviceID),
CONSTRAINT Orders_customerID_fk FOREIGN KEY (customerID) REFERENCES Customer(customerID));

CREATE TABLE OrderItem (
menuID VARCHAR2(4),
orderID VARCHAR2(4),
quantity NUMBER(4) ,
subtotal NUMBER(6,2),
CONSTRAINT OrderItem_pk PRIMARY KEY (menuID, orderID));

CREATE TABLE Membership (
membershipID VARCHAR2(5) PRIMARY KEY,
joinDate DATE NOT NULL,
membership_type VARCHAR2(10) DEFAULT 'bronze' CHECK (membership_type IN ('bronze', 'silver', 'gold')) NOT NULL,
discountPercentage NUMBER(3,2) DEFAULT 0.05 CHECK (discountPercentage IN (0.05, 0.10, 0.15)) NOT NULL,
customerID VARCHAR2(5) UNIQUE,
CONSTRAINT Membership_customerID_fk FOREIGN KEY (customerID) REFERENCES Customer(customerID));

CREATE TABLE Payment (
paymentID VARCHAR2(4) PRIMARY KEY,
paymentAmount NUMBER(6,2) CHECK (paymentAmount > 0) NOT NULL,
paymentTimestamp DATE NOT NULL,
paymentMethod VARCHAR2(11) CHECK (paymentMethod in ('Credit', 'Debit', 'QR Payment', 'Cash')),
orderID VARCHAR2(4) UNIQUE,
CONSTRAINT Payment_orderID_fk FOREIGN KEY (orderID) REFERENCES Orders(orderID));

CREATE TABLE Receipt (
receiptID VARCHAR2(4) PRIMARY KEY,
receiptTimestamp DATE NOT NULL,
receiptDetail VARCHAR2(250),
paymentID VARCHAR2(4) UNIQUE,
CONSTRAINT Receipt_paymentID_fk FOREIGN KEY (paymentID) REFERENCES Payment(paymentID));

CREATE TABLE Transaction_History (
th_ID VARCHAR2(5) PRIMARY KEY,
th_timestamp DATE NOT NULL,
transaction_status VARCHAR2(8) CHECK (transaction_status IN ('SUCCESS', 'FAIL', 'PENDING')),
customerID VARCHAR2(5),
paymentID VARCHAR2(4) UNIQUE,
CONSTRAINT Transaction_History_customerID_fk FOREIGN KEY (customerID) REFERENCES Customer(customerID),
CONSTRAINT Transaction_History_paymentID_fk FOREIGN KEY (paymentID) REFERENCES Payment(paymentID));

CREATE TABLE Promotion (
promotionID VARCHAR2(5) PRIMARY KEY,
promotion_name VARCHAR2(100) NOT NULL,
promotion_type VARCHAR2(15) CHECK (promotion_type IN ('Reward','Voucher')) NOT NULL,
StartDate DATE NOT NULL,
ExpDate DATE NOT NULL);

CREATE TABLE Voucher (
promotionID VARCHAR2(5) PRIMARY KEY,
voucher_code VARCHAR2(20) UNIQUE NOT NULL,
discount_value NUMBER(5,2) NOT NULL,
CONSTRAINT Voucher_promotionID_fk FOREIGN KEY (promotionID) REFERENCES Promotion(promotionID));

CREATE TABLE Reward (
promotionID VARCHAR2(5) PRIMARY KEY,
free_item VARCHAR2(20) NOT NULL,
CONSTRAINT Reward_promotionID_fk FOREIGN KEY (promotionID)
REFERENCES Promotion(promotionID));

CREATE TABLE Promotion_Used (
promotionID VARCHAR2(5),
orderID VARCHAR2(4),
redeem_Date DATE NOT NULL,
description VARCHAR2(200),
CONSTRAINT Promotion_Used_pk PRIMARY KEY (promotionID, orderID));

-- Insert into Menu
INSERT INTO Menu VALUES ('M001', 'Burger', 5.00);
INSERT INTO Menu VALUES ('M002', 'Pizza', 8.50);
INSERT INTO Menu VALUES ('M003', 'Pasta', 7.00);
INSERT INTO Menu VALUES ('M004', 'Salad', 4.50);
INSERT INTO Menu VALUES ('M005', 'Coffee', 3.00);
INSERT INTO Menu VALUES ('M006', 'Tea', 2.50);
INSERT INTO Menu VALUES ('M007', 'Apple Pie', 5.00);
INSERT INTO Menu VALUES ('M008', 'Steak', 15.00);
INSERT INTO Menu VALUES ('M009', 'Ice Cream', 3.50);
INSERT INTO Menu VALUES ('M010', 'Sandwich', 5.50);

-- Insert into Customization
INSERT INTO Customization VALUES ('C001', 'Extra Cheese', 1.00, 'M002');
INSERT INTO Customization VALUES ('C002', 'Add Bacon', 1.50, 'M001');
INSERT INTO Customization VALUES ('C003', 'Gluten Free', 2.00, 'M003');
INSERT INTO Customization VALUES ('C004', 'Vegan Option', 1.20, 'M004');
INSERT INTO Customization VALUES ('C005', 'Large Size', 0.80, 'M005');
INSERT INTO Customization VALUES ('C006', 'Honey Added', 0.60, 'M006');
INSERT INTO Customization VALUES ('C007', 'Spicy', 0.50, 'M007');
INSERT INTO Customization VALUES ('C008', 'Double Meat', 2.50, 'M008');
INSERT INTO Customization VALUES ('C009', 'Extra Scoop', 1.00, 'M009');
INSERT INTO Customization VALUES ('C010', 'Whole Grain Bread', 0.70, 'M010');

-- Insert into Customer
INSERT INTO Customer VALUES ('CU001', 'Alice', '0123456789', 'alice@email.com');
INSERT INTO Customer VALUES ('CU002', 'Bob', '0132345678', 'bob@email.com');
INSERT INTO Customer VALUES ('CU003', 'Charlie', '0143456789', 'charlie@email.com');
INSERT INTO Customer VALUES ('CU004', 'David', '0154567890', 'david@email.com');
INSERT INTO Customer VALUES ('CU005', 'Eva', '0165678901', 'eva@email.com');
INSERT INTO Customer VALUES ('CU006', 'Frank', '0176789012', 'frank@email.com');
INSERT INTO Customer VALUES ('CU007', 'Grace', '0187890123', 'grace@email.com');
INSERT INTO Customer VALUES ('CU008', 'Hannah', '0198901234', 'hannah@email.com');
INSERT INTO Customer VALUES ('CU009', 'Ian', '0119012345', 'ian@email.com');
INSERT INTO Customer VALUES ('CU010', 'Jane', '0120123456', 'jane@email.com');

-- Insert into Feedback
INSERT INTO Feedback VALUES ('F001', 5, 'Good.', 'CU001');
INSERT INTO Feedback VALUES ('F002', 1, 'Long waiting time.', 'CU002');
INSERT INTO Feedback VALUES ('F003', 3, 'Normal.', 'CU003');
INSERT INTO Feedback VALUES ('F004', 2, 'Bad.', 'CU004');
INSERT INTO Feedback VALUES ('F005', 2, 'I wouldn''t come again.', 'CU005');
INSERT INTO Feedback VALUES ('F006', 5, 'The dishes is delicious.', 'CU006');
INSERT INTO Feedback VALUES ('F007', 4, 'The waiter is nice.', 'CU007');
INSERT INTO Feedback VALUES ('F008', 5, 'Excellent.', 'CU008');
INSERT INTO Feedback VALUES ('F009', 5, 'I love the chicken burger.', 'CU009');
INSERT INTO Feedback VALUES ('F010', 3, 'Neutral.', 'CU010');


-- Insert into Employee
INSERT INTO Employee VALUES ('E001', 'John', '0182345678', 'Morning', 2500.00);
INSERT INTO Employee VALUES ('E002', 'Lisa', '0192345678', 'Evening', 2600.00);
INSERT INTO Employee VALUES ('E003', 'Mark', '0161234567', 'Night', 2700.00);
INSERT INTO Employee VALUES ('E004', 'Nina', '0172345678', 'Morning', 2400.00);
INSERT INTO Employee VALUES ('E005', 'Oscar', '0153456789', 'Evening', 2300.00);
INSERT INTO Employee VALUES ('E006', 'Paul', '0144567890', 'Night', 2800.00);
INSERT INTO Employee VALUES ('E007', 'Quincy', '0135678901', 'Morning', 2500.00);
INSERT INTO Employee VALUES ('E008', 'Rachel', '0126789012', 'Evening', 2700.00);
INSERT INTO Employee VALUES ('E009', 'Steve', '0197890123', 'Night', 2600.00);
INSERT INTO Employee VALUES ('E010', 'Tina', '0188901234', 'Morning', 2550.00);

-- Insert into Service
INSERT INTO Service VALUES ('S001', 'Table_Service');
INSERT INTO Service VALUES ('S002', 'Delivery');
INSERT INTO Service VALUES ('S003', 'Table_Service');
INSERT INTO Service VALUES ('S004', 'Delivery');
INSERT INTO Service VALUES ('S005', 'Table_Service');
INSERT INTO Service VALUES ('S006', 'Delivery');
INSERT INTO Service VALUES ('S007', 'Table_Service');
INSERT INTO Service VALUES ('S008', 'Delivery');
INSERT INTO Service VALUES ('S009', 'Table_Service');
INSERT INTO Service VALUES ('S010', 'Delivery');

-- Insert into Table_Service
INSERT INTO Table_Service VALUES ('S001', 'T01');
INSERT INTO Table_Service VALUES ('S003', 'T02');
INSERT INTO Table_Service VALUES ('S005', 'T03');
INSERT INTO Table_Service VALUES ('S007', 'T04');
INSERT INTO Table_Service VALUES ('S009', 'T05');

-- Insert into Delivery
INSERT INTO Delivery VALUES ('S002', 5.00, '23, Jalan Ampang, Kuala Lumpur');
INSERT INTO Delivery VALUES ('S004', 4.50, '5, Jalan Tun Razak, Kuala Lumpur');
INSERT INTO Delivery VALUES ('S006', 6.00, '1, Jalan Bukit Bintang, Kuala Lumpur');
INSERT INTO Delivery VALUES ('S008', 4.80, '3, Jalan Kuchai Lama, Kuala Lumpur');
INSERT INTO Delivery VALUES ('S010', 5.50, '12, Jalan Bangsar, Kuala Lumpur');

-- Insert into Orders
INSERT INTO Orders VALUES ('O001', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 10, 8, 2, 'E001', 'S001', 'CU001');
INSERT INTO Orders VALUES ('O002', TO_DATE('2025-04-02', 'YYYY-MM-DD'), 8.5, 8, 0.5, 'E002', 'S002', 'CU002');
INSERT INTO Orders VALUES ('O003', TO_DATE('2025-04-03', 'YYYY-MM-DD'), 21, 19, 2, 'E003', 'S003', 'CU003');
INSERT INTO Orders VALUES ('O004', TO_DATE('2025-04-04', 'YYYY-MM-DD'), 9, 6.5, 2.5, 'E004', 'S004', 'CU004');
INSERT INTO Orders VALUES ('O005', TO_DATE('2025-04-05', 'YYYY-MM-DD'), 15, 12, 3, 'E005', 'S005', 'CU005');
INSERT INTO Orders VALUES ('O006', TO_DATE('2025-04-06', 'YYYY-MM-DD'), 7.5, 7, 0.5, 'E006', 'S006', 'CU006');
INSERT INTO Orders VALUES ('O007', TO_DATE('2025-04-07', 'YYYY-MM-DD'), 10, 8, 2, 'E007', 'S007', 'CU007');
INSERT INTO Orders VALUES ('O008', TO_DATE('2025-04-08', 'YYYY-MM-DD'), 30, 25, 5, 'E008', 'S008', 'CU008');
INSERT INTO Orders VALUES ('O009', TO_DATE('2025-04-09', 'YYYY-MM-DD'), 10.5, 9, 1.5, 'E009', 'S009', 'CU009');
INSERT INTO Orders VALUES ('O010', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 11, 9, 2, 'E010', 'S010', 'CU010');


-- Insert into OrderItem
INSERT INTO OrderItem VALUES ('M001', 'O001', 2, 10.00);
INSERT INTO OrderItem VALUES ('M002', 'O002', 1, 8.50);
INSERT INTO OrderItem VALUES ('M003', 'O003', 3, 21.00);
INSERT INTO OrderItem VALUES ('M004', 'O004', 2, 9.00);
INSERT INTO OrderItem VALUES ('M005', 'O005', 5, 15.00);
INSERT INTO OrderItem VALUES ('M006', 'O006', 3, 7.50);
INSERT INTO OrderItem VALUES ('M007', 'O007', 1, 10.00);
INSERT INTO OrderItem VALUES ('M008', 'O008', 2, 30.00);
INSERT INTO OrderItem VALUES ('M009', 'O009', 3, 10.50);
INSERT INTO OrderItem VALUES ('M010', 'O010', 2, 11.00);

-- Insert into Membership
INSERT INTO Membership VALUES ('MB001', TO_DATE('2025-04-01', 'YYYY-MM-DD'), 'bronze', 0.05, 'CU001');
INSERT INTO Membership VALUES ('MB002', TO_DATE('2025-04-02', 'YYYY-MM-DD'), 'silver', 0.10, 'CU002');
INSERT INTO Membership VALUES ('MB003', TO_DATE('2025-04-03', 'YYYY-MM-DD'), 'gold', 0.15, 'CU003');
INSERT INTO Membership VALUES ('MB004', TO_DATE('2025-04-04', 'YYYY-MM-DD'), 'bronze', 0.05, 'CU004');
INSERT INTO Membership VALUES ('MB005', TO_DATE('2025-04-05', 'YYYY-MM-DD'), 'silver', 0.10, 'CU005');
INSERT INTO Membership VALUES ('MB006', TO_DATE('2025-04-06', 'YYYY-MM-DD'), 'gold', 0.15, 'CU006');
INSERT INTO Membership VALUES ('MB007', TO_DATE('2025-04-07', 'YYYY-MM-DD'), 'bronze', 0.05, 'CU007');
INSERT INTO Membership VALUES ('MB008', TO_DATE('2025-04-08', 'YYYY-MM-DD'), 'silver', 0.10, 'CU008');
INSERT INTO Membership VALUES ('MB009', TO_DATE('2025-04-09', 'YYYY-MM-DD'), 'gold', 0.15, 'CU009');
INSERT INTO Membership VALUES ('MB010', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 'bronze', 0.05, 'CU010');

-- Insert into Payment
INSERT INTO Payment VALUES ('P001', 8, TO_DATE('2025-04-01 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cash', 'O001');
INSERT INTO Payment VALUES ('P002', 8.5, TO_DATE('2025-04-02 11:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Credit', 'O002');
INSERT INTO Payment VALUES ('P003', 19, TO_DATE('2025-04-03 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Debit', 'O003');
INSERT INTO Payment VALUES ('P004', 6.5, TO_DATE('2025-04-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'QR Payment', 'O004');
INSERT INTO Payment VALUES ('P005', 12, TO_DATE('2025-04-05 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cash', 'O005');
INSERT INTO Payment VALUES ('P006', 7, TO_DATE('2025-04-06 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Credit', 'O006');
INSERT INTO Payment VALUES ('P007', 8, TO_DATE('2025-04-07 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Debit', 'O007');
INSERT INTO Payment VALUES ('P008', 25, TO_DATE('2025-04-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'QR Payment', 'O008');
INSERT INTO Payment VALUES ('P009', 9, TO_DATE('2025-04-09 18:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cash', 'O009');
INSERT INTO Payment VALUES ('P010', 9, TO_DATE('2025-04-10 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Credit', 'O010');

-- Insert into Receipt
INSERT INTO Receipt VALUES ('R001', TO_DATE('2025-04-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 1', 'P001');
INSERT INTO Receipt VALUES ('R002', TO_DATE('2025-04-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 2', 'P002');
INSERT INTO Receipt VALUES ('R003', TO_DATE('2025-04-03 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 3', 'P003');
INSERT INTO Receipt VALUES ('R004', TO_DATE('2025-04-04 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 4', 'P004');
INSERT INTO Receipt VALUES ('R005', TO_DATE('2025-04-05 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 5', 'P005');
INSERT INTO Receipt VALUES ('R006', TO_DATE('2025-04-06 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 6', 'P006');
INSERT INTO Receipt VALUES ('R007', TO_DATE('2025-04-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 7', 'P007');
INSERT INTO Receipt VALUES ('R008', TO_DATE('2025-04-08 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 8', 'P008');
INSERT INTO Receipt VALUES ('R009', TO_DATE('2025-04-09 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 9', 'P009');
INSERT INTO Receipt VALUES ('R010', TO_DATE('2025-04-10 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Receipt 10', 'P010');

-- Insert into Transaction_History
INSERT INTO Transaction_History VALUES ('TH001', TO_DATE('2025-04-01 11:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU001', 'P001');
INSERT INTO Transaction_History VALUES ('TH002', TO_DATE('2025-04-02 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU002', 'P002');
INSERT INTO Transaction_History VALUES ('TH003', TO_DATE('2025-04-03 13:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU003', 'P003');
INSERT INTO Transaction_History VALUES ('TH004', TO_DATE('2025-04-04 15:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU004', 'P004');
INSERT INTO Transaction_History VALUES ('TH005', TO_DATE('2025-04-05 17:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU005', 'P005');
INSERT INTO Transaction_History VALUES ('TH006', TO_DATE('2025-04-06 19:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU006', 'P006');
INSERT INTO Transaction_History VALUES ('TH007', TO_DATE('2025-04-07 10:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU007', 'P007');
INSERT INTO Transaction_History VALUES ('TH008', TO_DATE('2025-04-08 14:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU008', 'P008');
INSERT INTO Transaction_History VALUES ('TH009', TO_DATE('2025-04-09 18:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU009', 'P009');
INSERT INTO Transaction_History VALUES ('TH010', TO_DATE('2025-04-10 21:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'SUCCESS', 'CU010', 'P010');

-- Insert into Promotion
INSERT INTO Promotion VALUES ('PR001', 'Summer Sale', 'Voucher', TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-05-01', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR002', 'Winter Sale', 'Voucher', TO_DATE('2025-04-02', 'YYYY-MM-DD'), TO_DATE('2025-05-02', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR003', 'Free Coffee', 'Reward', TO_DATE('2025-04-03', 'YYYY-MM-DD'), TO_DATE('2025-05-03', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR004', 'Discount Bonanza', 'Voucher', TO_DATE('2025-04-04', 'YYYY-MM-DD'), TO_DATE('2025-05-04', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR005', 'Holiday Special', 'Reward', TO_DATE('2025-04-05', 'YYYY-MM-DD'), TO_DATE('2025-05-05', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR006', 'Year End Sale', 'Voucher', TO_DATE('2025-04-06', 'YYYY-MM-DD'), TO_DATE('2025-05-06', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR007', 'Gift Time', 'Reward', TO_DATE('2025-04-07', 'YYYY-MM-DD'), TO_DATE('2025-05-07', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR008', 'Food Festival', 'Voucher', TO_DATE('2025-04-08', 'YYYY-MM-DD'), TO_DATE('2025-05-08', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR009', 'Voucher Blast', 'Reward', TO_DATE('2025-04-09', 'YYYY-MM-DD'), TO_DATE('2025-05-09', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES ('PR010', 'Reward Me', 'Reward', TO_DATE('2025-04-10', 'YYYY-MM-DD'), TO_DATE('2025-05-10', 'YYYY-MM-DD'));

-- Insert into Voucher
INSERT INTO Voucher VALUES ('PR001', 'VOUCHER001', 5);
INSERT INTO Voucher VALUES ('PR002', 'VOUCHER002', 10);
INSERT INTO Voucher VALUES ('PR004', 'VOUCHER003', 7);
INSERT INTO Voucher VALUES ('PR006', 'VOUCHER004', 8);
INSERT INTO Voucher VALUES ('PR008', 'VOUCHER005', 9);

-- Insert into Reward
INSERT INTO Reward VALUES ('PR003', 'Coffee');
INSERT INTO Reward VALUES ('PR005', 'Cake');
INSERT INTO Reward VALUES ('PR007', 'Juice');
INSERT INTO Reward VALUES ('PR009', 'Burger');
INSERT INTO Reward VALUES ('PR010', 'Ice Cream');

-- Insert into Promotion_Used
INSERT INTO Promotion_Used VALUES ('PR001', 'O001', TO_DATE('2025-04-01 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Used 5$ voucher');
INSERT INTO Promotion_Used VALUES ('PR002', 'O002', TO_DATE('2025-04-02 11:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Used 10$ voucher');
INSERT INTO Promotion_Used VALUES ('PR003', 'O003', TO_DATE('2025-04-03 13:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'Got free coffee');
INSERT INTO Promotion_Used VALUES ('PR004', 'O004', TO_DATE('2025-04-04 15:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'Used 7$ voucher');
INSERT INTO Promotion_Used VALUES ('PR005', 'O005', TO_DATE('2025-04-05 17:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Got free cake');
INSERT INTO Promotion_Used VALUES ('PR006', 'O006', TO_DATE('2025-04-06 19:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Used 8$ voucher');
INSERT INTO Promotion_Used VALUES ('PR007', 'O007', TO_DATE('2025-04-07 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Got free juice');
INSERT INTO Promotion_Used VALUES ('PR008', 'O008', TO_DATE('2025-04-08 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Used 9$ voucher');
INSERT INTO Promotion_Used VALUES ('PR009', 'O009', TO_DATE('2025-04-09 18:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Got free burger');
INSERT INTO Promotion_Used VALUES ('PR010', 'O010', TO_DATE('2025-04-10 21:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Got free ice cream');

