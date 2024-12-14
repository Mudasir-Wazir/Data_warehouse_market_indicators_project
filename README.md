
# Economic Indicators Data Warehouse Project

This project implements a comprehensive **data warehouse** to analyze relationships between major economic indicators and market performance. By integrating historical data (1974–2013) from sources like the Federal Reserve Economic Data (FRED), it explores correlations between GDP, S&P 500, housing prices, and other metrics.

## Features

- **Star Schema Design**: Centralized `JULIAN_DAYS` time dimension connecting multiple fact tables:
  - **Daily Stock Market Data** (S&P 500 metrics)
  - **Quarterly Economic Metrics** (GDP, housing prices)
  - **Monthly Indicators** (CPI, unemployment rates)
    ![datacube](data cube.png)
- **OLAP Implementation**:
  - Analytical operations (slice, dice, drill-down, roll-up).
  - Query optimization with CTEs and temporary tables.
- **Visualization and Storytelling**:
  - Explores market volatility, cross-metric relationships, day-of-week trading patterns, and seasonal housing trends.
  - Key visuals like correlations between GDP, S&P 500, and housing market dynamics.

## Key Insights

1. **Market and Economic Correlation**:
   - Strong positive correlation between GDP and S&P 500 (0.923).
   - High correlation between housing prices and the stock market (0.901).
2. **Distinct Economic Phases**:
   - 1975–1993: Steady growth.
   - 1994–2007: Accelerated boom.
   - 2008–2013: Crisis and recovery.
3. **Critical Observations**:
   - Stock market recovers faster from downturns, while housing shows slower adjustment.

## Technologies Used

- **Data Source**: FRED database.
- **Database Design**: Dimensional modeling with a star schema.
- **Analytics**: SQL-based OLAP and visualization tools.
- **Tools**: Oracle Sql Developer, Tableau

## Applications

- **Investment Strategy Development**.
- **Risk Assessment and Management**.
- **Economic Policy Impact Evaluation**.

\
