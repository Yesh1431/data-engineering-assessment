DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'airbyte_ingestion') THEN
        CREATE ROLE airbyte_ingestion LOGIN PASSWORD 'airbyte_ingestion_pw';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'transform_role') THEN
        CREATE ROLE transform_role LOGIN PASSWORD 'transform_role_pw';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'reporting_role') THEN
        CREATE ROLE reporting_role LOGIN PASSWORD 'reporting_role_pw';
    END IF;
END
$$;

GRANT CONNECT ON DATABASE assessment TO airbyte_ingestion, transform_role, reporting_role;

GRANT USAGE ON SCHEMA raw TO airbyte_ingestion, transform_role, reporting_role;
GRANT USAGE ON SCHEMA staging TO transform_role, reporting_role;
GRANT USAGE ON SCHEMA marts TO transform_role, reporting_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA raw TO airbyte_ingestion;
GRANT SELECT ON ALL TABLES IN SCHEMA raw TO transform_role, reporting_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA staging TO transform_role;
GRANT SELECT ON ALL TABLES IN SCHEMA staging TO reporting_role;

GRANT SELECT ON ALL TABLES IN SCHEMA marts TO transform_role, reporting_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA raw
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO airbyte_ingestion;

ALTER DEFAULT PRIVILEGES IN SCHEMA raw
GRANT SELECT ON TABLES TO transform_role, reporting_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA staging
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO transform_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA staging
GRANT SELECT ON TABLES TO reporting_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA marts
GRANT SELECT ON TABLES TO transform_role, reporting_role;