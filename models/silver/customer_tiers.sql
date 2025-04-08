CREATE OR REPLACE DYNAMIC TABLE YTL_{{environment}}.SILVER.CUSTOMER_TIERS
TARGET_LAG = DOWNSTREAM
WAREHOUSE = COMPUTE_XS
AS

SELECT
	TRANSFORM.Customer_ID, TRANSFORM.Customer_Name, TRANSFORM.TotalSalesPerCustomer, CASE
			WHEN TotalSalesPerCustomer >= 15000 THEN 'Platinum'
			WHEN TotalSalesPerCustomer >= 11000 THEN 'Gold'
			WHEN TotalSalesPerCustomer >= 5000 THEN 'Silver'
			ELSE 'Bronze'
	END AS CustomerTier 
	FROM
	(
		SELECT
			SUPERSTORE.CUSTOMER_ID AS Customer_ID, SUPERSTORE.CUSTOMER_NAME AS Customer_Name, SUM(Sales) AS TotalSalesPerCustomer
		FROM
			YTL_{{environment}}.BRONZE.SUPERSTORE
		GROUP BY 
			Customer_ID,
			Customer_Name   
	) TRANSFORM
	ORDER BY TotalSalesPerCustomer DESC;