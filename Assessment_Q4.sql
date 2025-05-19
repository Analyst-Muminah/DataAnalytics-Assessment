SELECT 
    u.id AS customer_id,
    u.first_name + ' ' + u.last_name AS name,
    -- Calculate tenure in months, minimum of 1 to avoid division by zero
    CASE 
        WHEN DATEDIFF(MONTH, u.date_joined, GETDATE()) = 0 THEN 1 
        ELSE DATEDIFF(MONTH, u.date_joined, GETDATE()) 
    END AS tenure_months,
    COUNT(s.id) AS total_transactions,
    
    -- CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
    -- Assuming avg_profit_per_transaction = 0.001 (0.1%)
    ROUND(
        ((COUNT(s.id) * 1.0) / 
        CASE 
            WHEN DATEDIFF(MONTH, u.date_joined, GETDATE()) = 0 THEN 1 
            ELSE DATEDIFF(MONTH, u.date_joined, GETDATE()) 
        END) * 12 * 0.001, 
    2) AS estimated_clv

FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON s.owner_id = u.id
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY 
    estimated_clv DESC;
