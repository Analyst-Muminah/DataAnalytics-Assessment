-- Analyze customer transaction frequency and categorize them
WITH MonthlyTransactions AS (
    -- Count number of transactions per user per month
    SELECT 
        s.owner_id,
        FORMAT(s.transaction_date, 'yyyy-MM') AS transaction_month,
        COUNT(*) AS transactions_in_month
    FROM [dbo].[savings_savingsaccount] s
    GROUP BY 
        s.owner_id,
        FORMAT(s.transaction_date, 'yyyy-MM')
),
AverageTransactions AS (
    -- Calculate average number of transactions per user per month
    SELECT 
        owner_id,
        AVG(transactions_in_month * 1.0) AS avg_transactions_per_month
    FROM MonthlyTransactions
    GROUP BY owner_id
),
CategorizedUsers AS (
    -- Assign frequency categories based on average monthly transactions
    SELECT 
        owner_id,
        avg_transactions_per_month,
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM AverageTransactions
)
-- Final aggregation to count customers per category and their average transaction frequency
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM CategorizedUsers
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
