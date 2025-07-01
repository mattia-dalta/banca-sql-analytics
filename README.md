# Bank Customer Analytics

## Project Description

**Banking Intelligence** aims to develop a supervised machine learning model to predict future customer behavior based on transaction data and product ownership characteristics.  
The goal of this project is to create a **denormalized table** enriched with a set of behavioral indicators (features), derived from the available tables in the database. These features will represent financial activity and customer engagement.

## Objective

The primary objective is to build a **feature table** for training machine learning models.  
The final table will be at the customer level (`id_cliente`) and will include both quantitative and qualitative indicators derived from:

- transaction history  
- account ownership  
- product types  

## Value Proposition

This project delivers a well-structured dataset that enables the extraction of advanced behavioral features for supervised learning tasks, offering several business advantages:

- **Customer behavior prediction**: Identify behavioral patterns to forecast actions such as new product purchases or account closures.  
- **Churn reduction**: Detect at-risk customers based on behavioral indicators and enable timely marketing intervention.  
- **Risk management improvement**: Segment customers by financial behavior and refine credit and risk strategies.  
- **Offer personalization**: Tailor products and services to customer preferences based on usage data.  
- **Fraud detection**: Identify anomalies in transaction types and amounts that may indicate fraud.

These insights will contribute to smarter decision-making, improved customer management, and sustainable business growth.

## Database Structure

The database consists of the following tables:

- **cliente**: Personal information (e.g., birth date).
- **conto**: Customer account data.
- **tipo_conto**: Description of different account types.
- **tipo_transazione**: Types of transactions.
- **transazioni**: All transactions linked to accounts.

## Behavioral Indicators

The indicators are calculated per customer (`id_cliente`) and include:

### Base Indicator

- Customer age (from the `cliente` table).

### Transaction Indicators (All Accounts)

- Number of **outgoing** transactions.  
- Number of **incoming** transactions.  
- Total **outgoing** transaction amount.  
- Total **incoming** transaction amount.

### Account Indicators

- Total number of accounts held.  
- Number of accounts held **by type** (one feature per account type).

### Transaction Indicators by Account Type

For each account type (e.g., base, business, private, family):

- Number of **outgoing** transactions.  
- Number of **incoming** transactions.  
- Total **outgoing** transaction amount.  
- Total **incoming** transaction amount.

## Denormalized Table Creation Plan

### 1. Table Joins

To build the final customer-level table, several `LEFT JOIN`s are performed between:

- `cliente`  
- `conto`  
- `tipo_conto`  
- `transazioni`  
- `tipo_transazione`  

This ensures that even customers without accounts or transactions are included.

### 2. Feature Calculation

Behavioral indicators are calculated using aggregation functions such as:

- `COUNT()` for frequency-based metrics  
- `SUM()` for transaction totals  
- `MAX()` for age calculation

These operations are grouped by customer ID to produce the final dataset.

---

✅ All SQL scripts used in this project are available in:

- `db_bancario.sql` – database schema and sample data  
- `final_exercise.sql` – complete feature engineering query
