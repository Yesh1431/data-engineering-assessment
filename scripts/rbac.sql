-- developer_role: local development and validation in dev schema
-- airbyte_ingestion: raw layer ingestion privileges
-- transform_role: dbt/staging/marts transformation privileges
-- reporting_role: read-only access to marts for BI/reporting

-- Create roles
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'developer_role') THEN
        CREATE ROLE developer_role;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'airbyte_ingestion') THEN
        CREATE ROLE airbyte_ingestion;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'transform_role') THEN
        CREATE ROLE transform_role;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'reporting_role') THEN
        CREATE ROLE reporting_role;
    END IF;
END
$$;

-- Schema access
GRANT USAGE ON SCHEMA raw TO airbyte_ingestion;
GRANT USAGE ON SCHEMA raw TO transform_role;
GRANT USAGE ON SCHEMA staging TO transform_role;
GRANT USAGE ON SCHEMA marts TO reporting_role;
GRANT USAGE ON SCHEMA dev TO developer_role;

-- Raw schema privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA raw TO airbyte_ingestion;
GRANT SELECT ON ALL TABLES IN SCHEMA raw TO transform_role;

-- Staging / marts privileges
GRANT CREATE, USAGE ON SCHEMA staging TO transform_role;
GRANT CREATE, USAGE ON SCHEMA marts TO transform_role;
GRANT SELECT ON ALL TABLES IN SCHEMA staging TO transform_role;
GRANT SELECT ON ALL TABLES IN SCHEMA marts TO reporting_role;

-- Developer privileges
GRANT CREATE, USAGE ON SCHEMA dev TO developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA dev TO developer_role;

-- Default privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA raw
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO airbyte_ingestion;

ALTER DEFAULT PRIVILEGES IN SCHEMA raw
GRANT SELECT ON TABLES TO transform_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA staging
GRANT SELECT ON TABLES TO transform_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA marts
GRANT SELECT ON TABLES TO reporting_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA dev
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO developer_role;