
-- GDP GROWTH and SP500 quarterly return
WITH MarketPerformance AS (
    SELECT 
        d.YEAR_NUM,
        d.QUARTER_NUM,
        AVG(f.CLOSE) AS Avg_SP500,
        -- LAG function to get the previous quarter's SP500 avg.
        LAG(AVG(f.CLOSE)) OVER (ORDER BY d.YEAR_NUM, d.QUARTER_NUM) AS Prev_SP500
    FROM DW110.SP500_INDEX_EOD_FACTS f
    JOIN DW110.JULIAN_DAYS_DIM d 
        ON f.JULIAN_DAY = d.JULIAN_DAY
    GROUP BY d.YEAR_NUM, d.QUARTER_NUM
)
SELECT 
    m.YEAR_NUM,
    m.QUARTER_NUM,
    -- Calculating SP500 Quarterly Return
    ((m.Avg_SP500 - m.Prev_SP500) / m.Prev_SP500) * 100 AS SP500_QuarterlyReturn,
    q.GDP,
    -- GDP Growth with LAG function
    ((q.GDP - LAG(q.GDP) OVER (ORDER BY q.ACTUAL_DATE)) / LAG(q.GDP) OVER (ORDER BY q.ACTUAL_DATE)) * 100 AS GDP_Growth
FROM MarketPerformance m
JOIN DW110.FACT_QUARTERLY_INDICATORS q 
    -- Join using TO_CHAR to extract YEAR and QUARTER from ACTUAL_DATE
    ON m.YEAR_NUM = TO_CHAR(q.ACTUAL_DATE, 'YYYY')
    AND m.QUARTER_NUM = TO_CHAR(q.ACTUAL_DATE, 'Q')
ORDER BY m.YEAR_NUM, m.QUARTER_NUM;


--corr between sp500 and gdp 
WITH MarketPerformance AS (
    SELECT 
        d.YEAR_NUM,
        d.QUARTER_NUM,
        round(AVG(f.CLOSE),3) AS Avg_SP500,
        LAG(AVG(f.CLOSE)) OVER (ORDER BY d.YEAR_NUM, d.QUARTER_NUM) AS Prev_SP500
    FROM DW110.SP500_INDEX_EOD_FACTS f
    JOIN DW110.JULIAN_DAYS_DIM d 
        ON f.JULIAN_DAY = d.JULIAN_DAY
    GROUP BY d.YEAR_NUM, d.QUARTER_NUM
),
LaggedGDP AS (
    SELECT 
        q.GDP,
        q.ACTUAL_DATE,
        LAG(q.GDP) OVER (ORDER BY q.ACTUAL_DATE) AS Lagged_GDP
    FROM DW110.FACT_QUARTERLY_INDICATORS q
)
SELECT 
   round(CORR(m.Avg_SP500, l.Lagged_GDP),3) AS SP500_GDP_Correlation
FROM MarketPerformance m
JOIN LaggedGDP l 
    ON m.YEAR_NUM = TO_CHAR(l.ACTUAL_DATE, 'YYYY')
    AND m.QUARTER_NUM = TO_CHAR(l.ACTUAL_DATE, 'Q')



SELECT 
  m.year_num,m.quarter_num,m.AVG_SP500,l.lagged_gdp
FROM MarketPerformance m
JOIN LaggedGDP l 
    ON m.YEAR_NUM = TO_CHAR(l.ACTUAL_DATE, 'YYYY')
    AND m.QUARTER_NUM = TO_CHAR(l.ACTUAL_DATE, 'Q')

--quarterly avg sp500 with lagged HPI

WITH MarketPerformance AS (
    SELECT 
        d.YEAR_NUM,
        d.QUARTER_NUM,
        round(AVG(f.CLOSE),3) AS Avg_SP500,
        LAG(AVG(f.CLOSE)) OVER (ORDER BY d.YEAR_NUM, d.QUARTER_NUM) AS Prev_SP500
    FROM DW110.SP500_INDEX_EOD_FACTS f
    JOIN DW110.JULIAN_DAYS_DIM d 
        ON f.JULIAN_DAY = d.JULIAN_DAY
    GROUP BY d.YEAR_NUM, d.QUARTER_NUM
),
LaggedHPI AS (
    SELECT 
        q.HOUSE_PRICE_INDEX,
        q.ACTUAL_DATE,
        LAG(q.HOUSE_PRICE_INDEX) OVER (ORDER BY q.ACTUAL_DATE) AS Lagged_HPI
    FROM DW110.FACT_QUARTERLY_INDICATORS q
)

SELECT 
   round(CORR(m.Avg_SP500, l.Lagged_HPI),3) AS SP500_HPI_Correlation
FROM MarketPerformance m
JOIN LaggedHPI l 
    ON m.YEAR_NUM = TO_CHAR(l.ACTUAL_DATE, 'YYYY')
    AND m.QUARTER_NUM = TO_CHAR(l.ACTUAL_DATE, 'Q')
    
    
    
    
SELECT 
  m.year_num,m.quarter_num,m.AVG_SP500,l.lagged_HPI
FROM MarketPerformance m
JOIN LaggedHPI l 
    ON m.YEAR_NUM = TO_CHAR(l.ACTUAL_DATE, 'YYYY')
    AND m.QUARTER_NUM = TO_CHAR(l.ACTUAL_DATE, 'Q')

-- used with above for crrelation between HPI and Sp500





---Volume Analysis by Day of Week:

SELECT 
    d.DAY_NAME,
    round(AVG(f.VOLUME),3) as avg_volume,
    round(AVG(f.CLOSE - f.OPEN),3) as avg_price_change
FROM DW110.SP500_INDEX_EOD_FACTS f
JOIN DW110.JULIAN_DAYS_DIM d ON f.JULIAN_DAY = d.JULIAN_DAY
GROUP BY d.DAY_NAME
ORDER BY avg_volume DESC;


--- quarterly avg of all indicators 

SELECT 
    q.ACTUAL_DATE,
    q.GDP,
    q.HOUSE_PRICE_INDEX,
    AVG(f.CLOSE) as avg_sp500_price,
    AVG(m.CPI) as avg_cpi,
    AVG(m.UNRATE) as avg_unemployment_rate
FROM DW110.FACT_QUARTERLY_INDICATORS q
JOIN DW110.JULIAN_DAYS_DIM d ON q.JULIAN_DAY = d.JULIAN_DAY
JOIN DW110.SP500_INDEX_EOD_FACTS f ON d.JULIAN_DAY = f.JULIAN_DAY
JOIN DW110.FACT_MONTHLY_INDICATORS m ON d.JULIAN_DAY = m.JULIAN_DAY
GROUP BY q.ACTUAL_DATE, q.GDP, q.HOUSE_PRICE_INDEX
ORDER BY q.ACTUAL_DATE;


--- Price Volatility
SELECT 
    d.YEAR_NUM,
    d.MONTH_NAME,
    round(STDDEV((f.HIGH - f.LOW)/f.OPEN * 100),3) as price_volatility,
    round(AVG(f.VOLUME),3) as avg_volume
FROM DW110.SP500_INDEX_EOD_FACTS f
JOIN DW110.JULIAN_DAYS_DIM d ON f.JULIAN_DAY = d.JULIAN_DAY
GROUP BY d.YEAR_NUM, d.MONTH_NAME
ORDER BY price_volatility DESC;




--- HPI Yearly Growth
SELECT 
   d.YEAR_NUM,
   AVG(q.HOUSE_PRICE_INDEX) as avg_hpi_yearly,
   ROUND(((AVG(q.HOUSE_PRICE_INDEX) - LAG(AVG(q.HOUSE_PRICE_INDEX)) OVER 
       (ORDER BY d.YEAR_NUM)) / LAG(AVG(q.HOUSE_PRICE_INDEX)) 
       OVER (ORDER BY d.YEAR_NUM) * 100), 3) as yearly_growth_pct
FROM DW110.FACT_QUARTERLY_INDICATORS q
JOIN DW110.JULIAN_DAYS_DIM d ON q.JULIAN_DAY = d.JULIAN_DAY
GROUP BY d.YEAR_NUM
ORDER BY d.YEAR_NUM;

--- HPI by quarters 
SELECT 
    QUARTER_NUM,
    round(AVG(house_price_idx),3) as avg_house_price,
    round(AVG(quarterly_growth_pct),3) as avg_quarterly_growth
FROM (
    SELECT 
        d.QUARTER_NUM,
        AVG(q.HOUSE_PRICE_INDEX) as house_price_idx,
        ((AVG(q.HOUSE_PRICE_INDEX) - LAG(AVG(q.HOUSE_PRICE_INDEX)) OVER 
            (ORDER BY d.YEAR_NUM, d.QUARTER_NUM)) / LAG(AVG(q.HOUSE_PRICE_INDEX)) 
            OVER (ORDER BY d.YEAR_NUM, d.QUARTER_NUM) * 100) as quarterly_growth_pct
    FROM DW110.FACT_QUARTERLY_INDICATORS q
    JOIN DW110.JULIAN_DAYS_DIM d ON q.JULIAN_DAY = d.JULIAN_DAY
    GROUP BY d.YEAR_NUM, d.QUARTER_NUM
)
GROUP BY QUARTER_NUM
ORDER BY QUARTER_NUM;



