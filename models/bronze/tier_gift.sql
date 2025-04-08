CREATE OR REPLACE TABLE YTL_{{environment}}.BRONZE.TIER_GIFT (
    TIER VARCHAR,
    GIFT VARCHAR
);

INSERT INTO YTL_{{environment}}.BRONZE.TIER_GIFT VALUES ('Platinum', '$50 Vouchers');
INSERT INTO YTL_{{environment}}.BRONZE.TIER_GIFT VALUES ('Gold', '$30 Vouchers');