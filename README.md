<div align="center">

# 🍽️ POS Database System

**An Oracle data layer for restaurant ordering, payment, promotion, membership, and receipt workflows.**

![Oracle SQL](https://img.shields.io/badge/Oracle-SQL-F80000?style=flat-square&logo=oracle&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-Procedures%20%26%20Functions-1F2937?style=flat-square)
![Schema](https://img.shields.io/badge/Schema-18%20Tables-2563EB?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-16A34A?style=flat-square)

</div>

## 🎯 Product Promise

Keep a restaurant POS workflow consistent from menu selection to payment history. The schema models the operational records behind counter and kiosk ordering while PL/SQL modules provide reusable updates, lookups, calculations, and transaction utilities.

## 🔎 Problem

A POS database must connect customers, employees, service modes, orders, payments, promotions, and receipts without losing traceability. It also needs domain rules for ratings, membership tiers, payment methods, transaction states, and menu customization pricing.

## ✨ Capabilities

- Models dine-in and delivery through a shared service record with specialized detail tables.
- Connects orders to customers, employees, payment, receipts, and transaction history.
- Supports menu prices, item customization charges, discounts, vouchers, and rewards.
- Enforces primary keys, declared foreign keys, uniqueness rules, value checks, and required fields.
- Provides query examples plus eight procedures and eight functions across four functional SQL modules.
- Includes representative seed records for inspecting queries and PL/SQL behavior.

## 🗺️ Schema Architecture

The consolidated script defines **18 tables**. Solid relationships below are declared foreign keys. Relationships labelled `logical` use matching identifiers in the tables but are not declared as foreign-key constraints in the script.

```mermaid
erDiagram
    MENU {
        VARCHAR2 menuID PK
        VARCHAR2 itemName
        NUMBER itemPrice
    }
    CUSTOMIZATION {
        VARCHAR2 customizationID PK
        VARCHAR2 description
        NUMBER addPrice
        VARCHAR2 menuID FK
    }
    CUSTOMER {
        VARCHAR2 customerID PK
        VARCHAR2 name
        VARCHAR2 phoneNo UK
        VARCHAR2 email UK
    }
    EMPLOYEE {
        VARCHAR2 employeeID PK
        VARCHAR2 e_name
        VARCHAR2 working_slot
        NUMBER salary
    }
    FEEDBACK {
        VARCHAR2 feedbackID PK
        NUMBER rating
        VARCHAR2 f_comment
        VARCHAR2 customerID FK
    }
    SERVICE {
        VARCHAR2 serviceID PK
        VARCHAR2 service_type
    }
    TABLE_SERVICE {
        VARCHAR2 serviceID PK,FK
        VARCHAR2 table_No
    }
    DELIVERY {
        VARCHAR2 serviceID PK,FK
        NUMBER delivery_fee
        VARCHAR2 address
    }
    ORDERS {
        VARCHAR2 orderID PK
        DATE orderDate
        NUMBER totalAmount
        NUMBER finalAmount
        VARCHAR2 employeeID FK
        VARCHAR2 serviceID FK
        VARCHAR2 customerID FK
    }
    ORDERITEM {
        VARCHAR2 menuID PK
        VARCHAR2 orderID PK
        NUMBER quantity
        NUMBER subtotal
    }
    MEMBERSHIP {
        VARCHAR2 membershipID PK
        VARCHAR2 membership_type
        NUMBER discountPercentage
        VARCHAR2 customerID FK,UK
    }
    PAYMENT {
        VARCHAR2 paymentID PK
        NUMBER paymentAmount
        DATE paymentTimestamp
        VARCHAR2 paymentMethod
        VARCHAR2 orderID FK,UK
    }
    RECEIPT {
        VARCHAR2 receiptID PK
        DATE receiptTimestamp
        VARCHAR2 receiptDetail
        VARCHAR2 paymentID FK,UK
    }
    TRANSACTION_HISTORY {
        VARCHAR2 th_ID PK
        DATE th_timestamp
        VARCHAR2 transaction_status
        VARCHAR2 customerID FK
        VARCHAR2 paymentID FK,UK
    }
    PROMOTION {
        VARCHAR2 promotionID PK
        VARCHAR2 promotion_name
        VARCHAR2 promotion_type
        DATE StartDate
        DATE ExpDate
    }
    VOUCHER {
        VARCHAR2 promotionID PK,FK
        VARCHAR2 voucher_code UK
        NUMBER discount_value
    }
    REWARD {
        VARCHAR2 promotionID PK,FK
        VARCHAR2 free_item
    }
    PROMOTION_USED {
        VARCHAR2 promotionID PK
        VARCHAR2 orderID PK
        DATE redeem_Date
        VARCHAR2 description
    }

    MENU ||--o{ CUSTOMIZATION : offers
    CUSTOMER ||--o{ FEEDBACK : submits
    SERVICE ||--o| TABLE_SERVICE : specializes
    SERVICE ||--o| DELIVERY : specializes
    EMPLOYEE ||--o{ ORDERS : handles
    SERVICE ||--o{ ORDERS : fulfills
    CUSTOMER ||--o{ ORDERS : places
    CUSTOMER ||--o| MEMBERSHIP : holds
    ORDERS ||--o| PAYMENT : receives
    PAYMENT ||--o| RECEIPT : produces
    CUSTOMER ||--o{ TRANSACTION_HISTORY : owns
    PAYMENT ||--o| TRANSACTION_HISTORY : records
    PROMOTION ||--o| VOUCHER : specializes
    PROMOTION ||--o| REWARD : specializes
    ORDERS ||--o{ ORDERITEM : "logical orderID"
    MENU ||--o{ ORDERITEM : "logical menuID"
    ORDERS ||--o{ PROMOTION_USED : "logical orderID"
    PROMOTION ||--o{ PROMOTION_USED : "logical promotionID"
```

## 🧩 PL/SQL Modules

| Module | Queries | Procedures | Functions |
|---|---|---|---|
| `Promotion_Transaction.sql` | Active vouchers; promotion usage by customer | Record promotion usage; delete a transaction | Count promotions; find a customer's latest transaction date |
| `Employee_Menu.sql` | Employee order workload; delivery payment view | Update employee details; update menu items | Look up item price; calculate base plus customization price |
| `Payment_Receipt_Service.sql` | Employee and customer service views | Update payments; update receipts | Sum delivery fees; count successful transactions |
| `Customer_Membership_Feedback.sql` | Ratings, memberships, and customer payment history | Update customers; update memberships | Generate receipt text; calculate average rating |

## 🛠️ Technology

| Layer | Technology |
|---|---|
| Database | Oracle Database |
| Definition and queries | Oracle SQL |
| Business logic | PL/SQL procedures and functions |
| Data integrity | PK, FK, UNIQUE, CHECK, NOT NULL, and composite-key constraints |
| Supporting references | CSV, XLSX, and DOCX |

## 🚀 Setup and Run

Use a disposable Oracle schema: the consolidated script begins with `DROP TABLE ... CASCADE CONSTRAINTS` and then creates and seeds the database.

1. Connect to the target schema with SQL*Plus or Oracle SQL Developer.
2. Run the consolidated schema and seed script:

   ```sql
   @sql/G036.sql
   ```

3. Run a functional module after the schema is available:

   ```sql
   @sql/Promotion_Transaction.sql
   @sql/Employee_Menu.sql
   @sql/Payment_Receipt_Service.sql
   @sql/Customer_Membership_Feedback.sql
   ```

The functional modules contain demonstration DML and explicit `COMMIT` statements. Review them before running against retained data.

## ✅ Validation and Boundaries

- The architecture and capability inventory were verified against the committed SQL definitions.
- The schema script contains 18 `CREATE TABLE` statements, eight declared procedures, and eight declared functions.
- Oracle execution is **not claimed** here; database availability, privileges, and client configuration are environment-specific.
- `OrderItem` and `Promotion_Used` use composite primary keys but do not declare foreign-key constraints in the consolidated script.
- This repository provides the database layer only; it does not include a POS user interface or application server.

## 📄 License

Released under the [MIT License](LICENSE).
