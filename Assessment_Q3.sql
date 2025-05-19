 -- Identify plans with zero confirmed inflows and no transactions for over 1 year
SELECT 
p.id AS plan_id,
   p.owner_id,
   CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(DAY, MAX(s.transaction_date), GETDATE()) AS inactivity_days
FROM [dbo].[plans_plan] p
LEFT JOIN [dbo].[savings_savingsaccount] s ON s.plan_id = p.id
GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
HAVING 
    SUM(ISNULL(s.confirmed_amount, 0)) = 0  -- No inflow ever
    AND MAX(s.transaction_date) IS NOT NULL       -- At least one transaction to track last date
    AND DATEDIFF(DAY, MAX(s.transaction_date), GETDATE()) > 365
ORDER BY inactivity_days DESC;
