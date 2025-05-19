 INTRODUCTION
I created a database named adashi_staging using the provided database dump. Initially, I encountered challenges inserting data in bulk due to the structure of the dump script which made me try different tools like Vs code and DBeaver.  I later solved this by importing a limited number of rows and then used window  and update functions to correctly match foreign and primary keys across tables. With the help of hints provided in the assessment file, I was able to successfully create and connect the four key tables.

All queries were tested and refined to ensure the output matched the structure of the expected results in the expected output provided.

Q1. High-Value Customers with Multiple Products

Objective: To identify customers who have both a funded savings plan and a funded investment plan, and rank them by total deposits. This insight supports cross-selling opportunities by highlighting users already engaging with multiple financial products.
Approach:
•	I queried the plans_plan table, which contains both savings and investment plans.
•	I used two boolean flags: is_regular_savings to identify savings plans and is_a_fund to identify investment plans.
•	I joined the users_customuser table to retrieve customer names, and combined their first and last names for a complete display.
•	I used CASE WHEN statements to separately count the number of funded savings and investment plans per user.
•	I then calculated the total deposit amount using the amount column from plans_plan.
•	Finally, I filtered the results using the HAVING clause to include only those users who have at least one savings and one investment plan, and sorted the result by total deposits in descending order.
Challenge: when I ran it there was no output for this scenario due to my the limited in database and I updated the plan table for some id to meet my criteria and the query brings the desired outcome

 Q2. Transaction Frequency Analysis
To solve this, I started by thinking about what the finance team really wanted, a way to group customers based on how often they use their savings account. The goal was to find out if they’re high, medium, or low-frequency users.
 Approach:
•	 I looked at how often each customer transacts per month. I used the ‘transaction_date’ in the savings_savingsaccount table and grouped it by year and month per user. This gave me a monthly count of transactions for each customer.
•	I calculated the average number of transactions per month for every customer. I needed this to understand their behavior over time, not just in one month.
•	Then, I created categories based on their average:
	If someone had 10 or more transactions per month, I called them “High Frequency”.
	If they had between 3 and 9, I marked them as “Medium Frequency”.
	And if they had 2 or less, I tagged them as “Low Frequency”.
•	Finally, I grouped everything by these frequency categories to see how many customers fell into each group and what their average transaction rate looked like.
This breakdown helps the finance team identify which users are actively using their accounts and where there might be opportunities for engagement or upselling.  
Challenge:  When I initially ran the query, the only frequency category returned was "Low Frequency". After some investigation, I discovered that all the owner_id entries in my dataset had only one transaction each. Once I manually updated the transaction counts to at least three for some users, the "Medium Frequency" category also appeared as expected.

Q3. Account Inactivity Alert  
For this task, I focused on identifying inactive accounts specifically, those that haven’t had any inflow transactions in over a year.
At first, I thought I might need an is_active column to detect this, but after checking the structure of the data, I realized I could use the confirmed_amount field instead. If the confirmed amount is zero, it clearly means no actual money came in which is a good indicator of inactivity.
 Approach:
•	I started by joining the plans_plan table with savings_savingsaccount, since all transactions are tied to a plan.
•	Then I used MAX (transaction_date) to find the most recent transaction date for each plan.
•	To measure inactivity, I calculated the number of days since that last transaction using DATEDIFF.
•	I made sure to filter the results to only include:
	Plans where the total confirmed amount is zero (i.e., no actual inflows),
	And the last transaction happened more than 365 days ago.
•	I also used a CASE statement to tag each plan as either "Savings" or "Investment", just to make the output easier to understand.
This method helps flag dormant accounts that haven’t seen any activity in a while useful for sending reminders or marketing re-engagement campaigns.

Q4. Customer Lifetime Value (CLV) Estimation
Objective: Estimate the Customer Lifetime Value for each customer based on how long they’ve had an account and how frequently they transact. The model assumes a profit of 0.1% per transaction, and the estimated CLV is calculated using the formula:
 CLV = (total_transactions / tenure_in_months) * 12 * avg_profit_per_transaction
Approach:
•	I started by pulling the necessary fields from the users_customuser and savings_savingsaccount tables. 
•	I calculated the account tenure in months by comparing the user’s date_joined with the current date. 
•	Lastly, I counted all their transactions and used the given formula to compute the estimated CLV.
Challenge:  
However, during the process, I realized some users had multiple registrations, meaning the same customer might appear in the database more than once with different IDs. If I had grouped the transactions using just the id, their CLV would have been fragmented or misrepresented.
To solve this, I grouped the data using a unique identifier — in this case, the email field. This allowed me to merge all transactions belonging to the same individual regardless of how many times they registered. I also used MIN (date_joined) to reflect the true start of their account for tenure calculation with this I realized the email wasn’t the same even though the names are so I couldn’t categorize it as duplicate anymore I had to later group by id.
Tenure Calculation Edge Cases:
Some users had registered recently (even within the same month). I had to make sure tenure didn’t come out as zero to avoid division errors, so I defaulted it to 1 month in such cases.






	
