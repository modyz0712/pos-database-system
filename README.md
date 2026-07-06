<div align="center">

# POS Database System

SQL and PL/SQL database design for **The Foodie**, a fast-food POS and kiosk system.

![SQL](https://img.shields.io/badge/SQL-Oracle-blue?style=for-the-badge)
![PLSQL](https://img.shields.io/badge/PL%2FSQL-Procedures%20%26%20Functions-orange?style=for-the-badge)
![Database](https://img.shields.io/badge/Database-Design%20%26%20Normalization-2563EB?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-111827?style=for-the-badge)

</div>

---

## Table of Contents

- [About](#about)
- [Problem Scope](#problem-scope)
- [Functional Scope](#functional-scope)
- [Business Rules](#business-rules)
- [My Individual SQL Work](#my-individual-sql-work)
- [Repository Structure](#repository-structure)
- [How to Run](#how-to-run)
- [Academic Context](#academic-context)
- [License](#license)

## About

This repository contains a Database Technology coursework project for a point-of-sale system and kiosk platform used by **The Foodie**, a fast-food restaurant. The database supports customer accounts, membership records, order placement, menu management, order customization, promotions, feedback, payment handling, and transaction history.

The published repository keeps the SQL scripts, data dictionary, sample table records, and final report so the project can be reviewed as database-design portfolio evidence.

## Problem Scope

The Foodie needs a database that can support both POS and kiosk operations. The system must keep customer, order, menu, payment, promotion, and transaction data consistent while allowing customers to place orders, apply rewards or vouchers, complete payment, and review transaction history.

The design focuses on:

- Structured relational modelling for restaurant POS workflows.
- Data integrity through primary keys, foreign keys, and constraints.
- Business rule support for paid orders, one-time promotion usage, feedback records, menu customization pricing, and transaction traceability.
- SQL and PL/SQL scripts that demonstrate query, procedure, and function logic.

## Functional Scope

| Area | What the database supports |
|---|---|
| Customer management | Customer profiles, contact details, and membership information |
| Membership | Membership records and discount-related support |
| Ordering | Orders, order details, and service-platform handling such as dine-in or delivery |
| Menu management | Menu items, base pricing, and customization/add-on pricing |
| Promotions | Voucher and reward records, promotion redemption, and usage tracking |
| Feedback | Customer feedback and rating records |
| Payment | Payment method records and receipt/transaction references |
| Transaction history | Historical records for reporting and customer reference |

## Business Rules

- Orders must be paid before they are sent for preparation.
- Each promotion code can only be used once per customer.
- Customers may leave feedback with a rating from 1 to 5 after completing an order.
- Menu item customizations add extra price on top of the base item price.
- Payments are recorded into transaction history immediately after payment completion.

## My Individual SQL Work

The report identifies **Koo Ian Hong** as contributing to the scope of work and data dictionary. The individual SQL file `sql/G036_KooIanHong.sql` also includes:

- Query to list active voucher promotions.
- Query to list promotions used by each customer.
- Stored procedure to insert promotion usage records.
- Stored procedure to delete a transaction by transaction-history ID.
- Function to count promotions by promotion type.
- Function to retrieve the latest transaction date for a customer.

## Repository Structure

```text
pos-database-system/
|-- sql/
|   |-- G036.sql
|   |-- G036_KooIanHong.sql
|   |-- G036_ChinZhengQuan.sql
|   |-- G036_LaiKeenSeng.sql
|   `-- G036_LimYiXiang.sql
|-- docs/
|   |-- Full_POS_System_Data_Dictionary.csv
|   |-- POS_All_Tables_Records.xlsx
|   |-- POS_System_Tables_Records.xlsx
|   `-- POS_Database_Report.docx
|-- LICENSE
`-- README.md
```

## How to Run

1. Open Oracle SQL Developer, SQL*Plus, or another Oracle-compatible SQL environment.
2. Run the consolidated schema script:

   ```sql
   @sql/G036.sql
   ```

3. Run individual SQL/PLSQL demonstration files if needed:

   ```sql
   @sql/G036_KooIanHong.sql
   ```

4. Review the data dictionary and sample records under `docs/`.

## License

This repository is released under the MIT License. See [LICENSE](LICENSE) for details.
