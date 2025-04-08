USE ROLE ACCOUNTADMIN;

CREATE OR ALTER WAREHOUSE DATAOPS_WH 
  WAREHOUSE_SIZE = XSMALL 
  AUTO_SUSPEND = 300 
  AUTO_RESUME= TRUE;


-- Separate database for git repository
CREATE OR ALTER DATABASE DATAOPS_COMMON;


-- API integration is needed for GitHub integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/AndriSoenoyo') -- INSERT YOUR GITHUB USERNAME HERE
  ENABLED = TRUE;


-- Git repository object is similar to external stage
CREATE OR REPLACE GIT REPOSITORY DATAOPS_COMMON.public.repo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/AndriSoenoyo/snowflake-dataops'; -- INSERT URL OF FORKED REPO HERE


CREATE OR ALTER DATABASE YTL_{{environment}};


-- To monitor data pipeline's completion
CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;

USE DATABASE YTL_{{environment}};

-- Database level objects
CREATE OR ALTER SCHEMA bronze;
CREATE OR ALTER SCHEMA silver;
CREATE OR ALTER SCHEMA gold;


-- Schema level objects
-- CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR REPLACE FILE FORMAT bronze.csv_format TYPE = 'csv', PARSE_HEADER = TRUE;
CREATE OR ALTER STAGE bronze.raw;


-- Copy file from GitHub to internal stage
-- copy files into @bronze.raw from @quickstart_common.public.quickstart_repo/branches/main/data/airport_list.json;
copy files into @bronze.raw from @DATAOPS_COMMON.public.repo/branches/dev/data/Global_Superstore2.csv;