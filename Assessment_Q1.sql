-- Select customers who have both savings and investment plans
SELECT 
    p.owner_id,  -- Customer ID from the plans table
    u.first_name + ' ' + u.last_name AS full_name,  -- Combine first and last names to get full name

    -- Count the number of distinct savings plans per customer
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

    -- Count the number of distinct investment plans per customer
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Calculate the total deposit amount across all plans
    SUM(COALESCE(p.amount, 0)) AS total_deposits
FROM [dbo].[plans_plan] p

-- Join with the users table to get customer names
LEFT JOIN [dbo].[users_customuser] u ON p.owner_id = u.id

-- Group the results by customer so we can aggregate per user
GROUP BY 
    p.owner_id,
    u.first_name, 
    u.last_name

-- Only include users who have at least one savings plan and one investment plan
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0 AND
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0

-- Sort by total deposits in descending order to highlight high-value customers
ORDER BY total_deposits DESC;

