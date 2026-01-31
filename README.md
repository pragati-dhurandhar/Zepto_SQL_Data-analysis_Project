# Zepto Inventory & Sales Performance Analysis (SQL)

## 📌 Project Overview
This project analyzes a comprehensive **Zepto Inventory Dataset** consisting of over 1,000+ stock-keeping units (SKUs). The dataset provides a granular look at quick-commerce operations, including product categorization, real-time stock status, weight metrics, and complex pricing structures (MRP vs. Discounted Prices).

## 🎯 Objectives
* **Data Integrity & Cleaning:** Perform robust EDA to identify null values, handle pricing anomalies (converting paise to rupees), and eliminate invalid records to ensure high-quality analysis.
* **Inventory Optimization:** Analyze stock-out patterns and "Critical Stock" levels to identify supply chain gaps and prevent revenue leakage.
* **Pricing Strategy:** Evaluate discount effectiveness and price-per-gram value to understand how Zepto balances "Budget" vs. "Premium" market segments.

## 🗄️ Database Schema
```sql
CREATE TABLE zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN, 
    quantity INTEGER
);
```

## 🔍 Key Business Questions Answered
This project provides data-driven answers to the following 15 business-critical questions:

1. Value Leadership: Top 10 best-value products based on discount percentage.

2. Revenue Risk: High-MRP products that are currently out of stock.

3. Revenue Estimation: Total estimated revenue per category based on available stock.
 
4. Low-Promo Premium Items: Products priced >₹500 with <10% discount.

5. Category Discounts: Top 5 categories offering the highest average discounts.

6. Unit Economics: Price-per-gram analysis for bulk products (>100g).

7. Product Segmentation: Classification of inventory into 'Low', 'Medium', and 'Bulk' weight categories.

8. Logistics Load: Total inventory weight per category for warehouse planning.

9. Opportunity Cost: Potential revenue lost due to out-of-stock items.

10. Bulk Value Search: High-weight (>500g) items priced under ₹100.

11. Supply Chain Health: Categories where over 20% of inventory is out of stock.

12. Competitive Pricing: Top 3 highest absolute discounts per category.

13. Segment Comparison: Average discount comparison between 'Premium' and 'Budget' segments.

14. System Auditing: Identifying pricing bugs and mathematical inconsistencies in discounts.

15. Pre-emptive Restocking: Identifying "In-Stock" items with critically low inventory (<10 units).

## 🚀 Technical Highlights
* Window Functions: Utilized RANK() over PARTITION BY to find top-performing products within specific categories.

* Conditional Logic: Implemented complex CASE statements to segment data by weight and price.

* Data Quality Assurance: Built custom scripts to detect and delete records with ₹0 MRP and fix unit conversion errors.

* Aggregation & Filtering: Advanced use of GROUP BY and HAVING to simulate real-world inventory reporting.
